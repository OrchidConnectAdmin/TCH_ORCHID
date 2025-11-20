@isTest
public with sharing class FON_RTNCalculatorTest
{
	@isTest
	static void testCalculate()
	{
		FON_RTNCalculator.calculate('000000000');
		FON_RTNCalculator.calculate('00000000');
		FON_RTNCalculator.calculate('0000000');
	}
}