#include <cassert>
#include <iostream>
#include <stdlib.h>

using namespace std;

class PinkNumber
{
	private:
		int max_key;
		int key;
		unsigned int white_values[5];
		unsigned int range;
	public:
		PinkNumber(unsigned int range = 128)
		{
			max_key = 0x1f; // Five bits set
			this->range = range;
			key = 0;
			for (int i = 0; i < 5; i++)
				white_values[i] = rand() % (range/5);
		}
		int GetNextValue()
		{
			int last_key = key;
			unsigned int sum;

			key++;
			if (key > max_key)
				key = 0;
			// Exclusive-Or previous value with current value. This gives
			// a list of bits that have changed.
			int diff = last_key ^ key;
			sum = 0;
			for (int i = 0; i < 5; i++)
			{
				// If bit changed get new random number for corresponding
				// white_value
				if (diff & (1 << i))
					white_values[i] = rand() % (range/5);
				sum += white_values[i];
			}
			return sum;
		}
};
//#ifdef DEBUG
int main()
{
	PinkNumber pn;

	FILE* fp = fopen("pink.raw", "wb");
	assert(fp);

	for (int i = 0; i < 80000; i++) {
		uint8_t pcm = pn.GetNextValue();
		fwrite(&pcm, 1, 1, fp);
	}
	fclose(fp);
}
//#endif // DEBUG

