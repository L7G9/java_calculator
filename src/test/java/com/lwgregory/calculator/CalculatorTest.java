package com.lwgregory.calculator;
import org.junit.jupiter.api.Test;
import static org.junit.Assert.assertEquals;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class CalculatorTest {

  private Calculator calculator = new Calculator();

  @Test
  public void testSum() throws Exception {
    assertEquals(5, calculator.sum(2, 3));
  }
}
