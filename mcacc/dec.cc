#include "dec.h"
#include "types.h"

std::string currency::stra() const { 
	//return "stra: " + std::to_string(value/100.99);
	//double d = std::decimal::decimal_to_double(dec); 
	return supo::format_num(double(value)/100.0, 2); 
}
currency::currency(int whole, int frac)
{
	value = whole * 100 + frac;
}
double currency::operator() () const 
{ 
	return double(value) / 100.0;
}
currency mul(const price& p, const quantity& q)
{
	return currency(p() * q());
}
price mul(const currency& c, const quantity& q)
{
	return price(c() * q());
}

price div(const currency& c, const quantity& q)
{
	double q1 = q.get();
	return price(double(c())/q1);
}

price sub(const price& p1, const price& p2)
{
			return price(p1()-p2());
}
std::string currency::str() const
{
	return std::to_string(double(value)/100.0);  // TODO ptolly needs fixingdd
}

std::string price::str() const
{
	return std::to_string(value);  // TODO ptolly needs fixingdd
}
std::string quantity::str() const
{
	return std::to_string(value);  // TODO ptolly needs fixingdd
}
std::string as_currency(const price& p) 
{ 
	//return currency(p.dbl()).str();
	return std::to_string(p());
}

std::string ret_curr(const currency& num, const currency& denom)
{
	return ret_str(num(), denom());
}	
/*
currency operator*(const price& p, const quantity& q)
{
	double v = p() * q();
	return currency(v);
}
currency operator*(const currency& c, const price& p)
{
	double v = c() * p();
	return currency(v);
}
*/
#if 0

using namespace std::decimal;

std::decimal::decimal128 dbl_to_dec(double d, int dp) { 
	double d1 = supo::bround(d * pow(10, dp));
	return std::decimal::make_decimal128((long long)d1, -dp); 
}

std::decimal::decimal128 str_to_dec(const std::string& s, int dp) { return dbl_to_dec(stod(s), dp); }
std::decimal::decimal128 str_to_dec(double sgn, const std::string& s, int dp) { return dbl_to_dec(sgn *stod(s), dp); }


price operator/(const currency& c, const quantity& q)
{
	decimal128 d128 = c.dec/q.dec;
	const price p(d128*100);
       	return p; 
}

currency operator*(const price& p, const quantity& q) { return currency(p.dbl()*q.dbl()/100); }



#endif
