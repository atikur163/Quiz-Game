package service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Random;

import org.junit.jupiter.api.Test;

import model.TrigQuestion;

/** Task 09 - test cases from the assignment. */
class MathServiceTest {

    // ---- prime ----

    @Test
    void primeNumbers() {
        assertEquals(1, MathService.isPrime(7));
        assertEquals(1, MathService.isPrime(2));
        assertEquals(1, MathService.isPrime(97));
        assertEquals(1, MathService.isPrime(2147483647));
    }

    @Test
    void notPrimeNumbers() {
        assertEquals(0, MathService.isPrime(8));
        assertEquals(0, MathService.isPrime(1));
        assertEquals(0, MathService.isPrime(0));
        assertEquals(0, MathService.isPrime(-7));
        assertEquals(0, MathService.isPrime(49));
    }

    // ---- modulus ----

    @Test
    void modulus() {
        assertEquals(2, MathService.calculateMod(17, 5));
        assertEquals(0, MathService.calculateMod(10, 5));
        assertEquals(-2, MathService.calculateMod(-17, 5));
        assertEquals(2, MathService.calculateMod(17, -5));
        assertEquals(0, MathService.calculateMod(0, 7));
    }

    @Test
    void zeroDivisorIsRejected() {
        assertThrows(IllegalArgumentException.class, () -> MathService.calculateMod(5, 0));
    }

    // ---- trigonometry ----

    @Test
    void trigonometricValues() {
        assertEquals(0.5, MathService.calculateSin(30), 1e-9);
        assertEquals(0.5, MathService.calculateCos(60), 1e-9);
        assertEquals(1.0, MathService.calculateTan(45), 1e-9);
        assertEquals(1.0, MathService.calculateSin(90), 1e-9);
        assertEquals(0.0, MathService.calculateCos(90), 1e-9);
    }

    @Test
    void pythagoreanIdentity() {
        for (int angle = 0; angle <= 360; angle += 15) {
            double s = MathService.calculateSin(angle);
            double c = MathService.calculateCos(angle);
            assertEquals(1.0, s * s + c * c, 1e-9);
        }
    }

    @Test
    void undefinedTangent() {
        assertTrue(Double.isNaN(MathService.calculateTan(90)));
        assertTrue(Double.isNaN(MathService.calculateTan(270)));
        assertFalse(Double.isNaN(MathService.calculateTan(60)));
    }

    // ---- answer checking ----

    @Test
    void trigAnswersUseTolerance() {
        assertTrue(MathService.isTrigAnswerCorrect("sin", 30, "0.5"));
        assertTrue(MathService.isTrigAnswerCorrect("sin", 30, "1/2"));
        assertTrue(MathService.isTrigAnswerCorrect("sin", 60, "0.87"));
        assertTrue(MathService.isTrigAnswerCorrect("tan", 60, "1.73"));
        assertTrue(MathService.isTrigAnswerCorrect("cos", 90, "0"));
        assertFalse(MathService.isTrigAnswerCorrect("sin", 30, "0.6"));
        assertFalse(MathService.isTrigAnswerCorrect("cos", 180, "1"));
    }

    @Test
    void undefinedAnswers() {
        assertTrue(MathService.isTrigAnswerCorrect("tan", 90, "undefined"));
        assertTrue(MathService.isTrigAnswerCorrect("tan", 270, "Undefined"));
        assertFalse(MathService.isTrigAnswerCorrect("tan", 45, "undefined"));
        assertFalse(MathService.isTrigAnswerCorrect("tan", 90, "1"));
    }

    @Test
    void parsingNumbers() {
        assertEquals(0.5, MathService.parseNumber("0.5"));
        assertEquals(0.5, MathService.parseNumber(".5"));
        assertEquals(-0.5, MathService.parseNumber("-1/2"));
        assertNull(MathService.parseNumber("abc"));
        assertNull(MathService.parseNumber("NaN"));
        assertNull(MathService.parseNumber("1/0"));
        assertNull(MathService.parseNumber(""));
    }

    // ---- scoring ----

    @Test
    void scoring() {
        assertEquals(10, MathService.calculateScore(true, true, true, true));
        assertEquals(0, MathService.calculateScore(false, false, false, false));
        assertEquals(8, MathService.calculateScore(true, false, true, true));
        assertEquals(4, MathService.calculateScore(true, true, false, false));
    }

    // ---- question generator ----

    @Test
    void generatedQuestionsAreDifferent() {
        Random random = new Random(42);
        for (int i = 0; i < 500; i++) {
            TrigQuestion first = MathService.generateTrigQuestion(random, null);
            TrigQuestion second = MathService.generateTrigQuestion(random, first);
            assertFalse(first.equals(second));
        }
    }
}
