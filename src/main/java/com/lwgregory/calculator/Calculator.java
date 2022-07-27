package com.lwgregory.calculator;
import org.springframework.stereotype.Service;

/**
 * Calculator buisiness logic
 */
@Service
public class Calculator {
	int sum(int a, int b) {
		return a + b;
	}
}
