# MIPS-Exercices

## **Menu part:**

- If the user enters one of the valid input values between 1 and 5:

![](https://github.com/beyzanc/MIPS-Exercices/blob/master/1.png)

- If the user enters an invalid value (e.g. 6) other than valid values:

![](https://github.com/beyzanc/MIPS-Exercices/blob/master/2.png)
- If the user wants to exit the program and enters 5 as input:

![](https://github.com/beyzanc/MIPS-Exercices/blob/master/3.png)
## **Implementation of Text Processing and Palindromic Sequence Generation in MIPS Architecture**

Firstly, the program displays "Input: " on the screen and prompts the user to input a text that will be stored in the area labeled as 'Q1UserString' and its starting address will be saved in the $s0 register. The maximum number of characters that can be entered is 199. To find the length of the text entered by the user, a loop labeled as 'FindLength' is used, and the length, which is initially set to 0, is stored in the $s1 register. The program uses the $2 register to store the starting address of the memory area of the array named 'Q1LetterAmount' to calculate the frequency of each letter in the user's input.

The 'FindLength' loop continues until a newline character is found, and $s1 is incremented for each character. Then, the program goes to the 'CountLetters' loop. Here, the loop is executed 's1' times, which is the number of characters in the user's input.

Then, each character is checked whether it is a letter or not. If the character is not a letter, the program goes to the 'NotLetter' label, and the count of that character is not calculated. Otherwise, the program checks whether the letter is uppercase or lowercase, and the index of the letter is calculated by subtracting the ASCII code of 'A' or 'a' from the letter's code. Using this index, the count of the relevant letter is stored in the 'Q1LetterAmount' memory area.

The part starting with the 'ConstructFirstHalf' label creates the first half of the palindrome by looking at the letter counts. The count of each letter is divided by two, and the half of that letter is added to the first half of the palindrome, which is stored in the '$s3' register.

Then, the created first half is repeated until it is reversed for the 'EndConstructFirstHalf' label. At the 'EndConstructFirstHalf' label, the created first half is reversed and placed in the 'Q1Palindrome' memory area as the second half of the palindrome. Additionally, the total length of the palindrome is calculated and stored in the $s4 register.

At the 'ConstructSecondHalf' label, the second half of the palindrome is created by reversing the first half created at the 'ConstructFirstHalf' label. Starting from the last element of the first half, each element is added to the second half of the palindrome, which is stored in the '$s3' register. Then, the length and the entire palindrome are printed on the screen by combining the 'Q1OutputMsg1', 'Q1Palindrome', 'Q1OutputMsg2', and '$s4' with the 'Q1OutputMsg3' texts.

![](https://github.com/beyzanc/MIPS-Exercices/blob/master/4.png)
![](https://github.com/beyzanc/MIPS-Exercices/blob/master/5.png)

## **Employing MIPS Instructions for Text Alteration and Vowel Reversal**

The program displays the "Q2InputMsg" content, which is the "Input: " text, prompting the user for input. The user's input text is stored in a memory area called "Q2UserString." After that, the length of the user input is found by traversing the “Q2UserString” until the program comes across the newline character. The length found is assigned to the register "$s1". To identify the vowels in the input text, the program uses a vowel string stored in the memory area "Q2Vowels," which is formatted as "aAeEiIoOuU."

The program first scans the input text in reverse, starting from the last character, and finds the vowels by comparing each character in the user input with the letters inside the “Q2Vowels” array, during the "FindReverseVowels" loop. The vowels found are stored in reverse order in the memory area called "Q2ReverseVowels."

Next, the program iterates through the characters in the input text in its original order, searching for vowels.. When a vowel is found, it is replaced with the next available vowel from the "Q2ReverseVowels" array during the "Q2ReverseUserInput" loop. Once this

process is complete, the program displays the "Output: " text followed by the modified text, which now has its vowels reversed. The program returns to the main menu to support new uses.

![](https://github.com/beyzanc/MIPS-Exercices/blob/master/6.png)

## **MIPS-based Approach to Prime and Square-Free Number Determination**

The program first asks the user to enter a number. First thing the program does with the number is checking if it is a prime number or not. If it is a prime number, then it means it is also a square-free number and the program prints the output according to it.

To understand if a number is prime or not, the program uses the “isPrime” procedure. In this procedure, the number is shifted right by 1 and this value is stored in another register; the original number remains untouched. Then, the procedure divides the original number by this value and checks if the remainder is zero. If the remainder is zero, the procedure returns 0. If the remainder is not equal to zero, the divider is decreased by 1. This loop continues until the divider becomes less than 2.

If the input is not a prime number, the program again uses the value of input shifted right by 1 and stores this value in another register ($t0). Then there comes a loop where the program, starting from 2 to $t0, checks each number if it is prime or not. If it is prime, the program divides the input by it.

After the division, if the remainder is not zero, the program continues with the next iteration of the loop. Then, the program divides the input by ($t0) \* ($t0). If the remainder is zero, it means that the input contains two of the same prime in its prime factorization, and the program understands that this number is not square-free, prints the necessary output. If this remainder is also not zero, then it means that the input contains only one of this prime number ($t0) in its prime factorization. This prime number is stored in a linked list and the program continues with the next iteration of the loop.

After the loop ends, the program prints the necessary outputs by using the linked list that stores the prime numbers which exist in the prime factorization of the input.

![](https://github.com/beyzanc/MIPS-Exercices/blob/master/7.png)
![](https://github.com/beyzanc/MIPS-Exercices/blob/master/8.png)

## **Matrix Manipulation and Identification of Lucky Numbers Utilizing MIPS Instruction Set**

The program first takes the number of rows and columns of the matrix from the user. The row count is stored in the $s0 register, while the column count is stored in the $s1 register. Then, it takes the elements of the matrix from the user in the form of an array, converts the elements to integers, and places them into the array stored in the $s2 register. Next, the program checks whether each element of the matrix is unique from one another using nested loops. If matching identical values are found, the text "The matrix should have only unique values." is printed on the screen and the program is terminated. If the values are unique, the program finds the minimum element in each row and the maximum element in each column. To find the minimum row elements, it uses a loop for each row, stores the lowest value, and adds it to the array in $s4. To find the maximum column elements, it uses a loop for each column, stores the highest value, and adds it to the array in $s5. Then, the program compares the minimum row and maximum column elements using nested loops to find the lucky numbers. If the same value is found as both the minimum row and maximum column element, it is considered a lucky number and added to the array in the $s6 register. Finally, if no lucky numbers are found, the text "There are no lucky numbers." is printed on the screen. If lucky numbers are found, the text "The lucky numbers are: " is printed on the screen, followed by the lucky numbers.

**Note: In order for the program to work correctly, there must be no space before the input and exactly one space between inputs, when entering the matrix elements.**

![](https://github.com/beyzanc/MIPS-Exercices/blob/master/9.png)
![](https://github.com/beyzanc/MIPS-Exercices/blob/master/10.png)
