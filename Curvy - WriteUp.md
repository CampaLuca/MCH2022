## CURVY - MCH2022

### Challenge
Connect to the service: `nc curvy.ctf.zone 6011`
It asks us to tell what is the step at which we are able to reach the x-coordinate 1337. 

### Trying to use the service
1) If we put `0` it says `you remain in the starting position`
2) If we put `1` we reach a point with x-coordinate `1`
3) If we put `2` we reach a point with x-coordinate `10246385595908412093322394614482812`
4) If we put `3` we reach a point with x-coordinate `39363994084598900187252501570838981`
5) If we put `4` we reach a point with x-coordinate `21407548750102312410625794491436912`

In practice, what the service is doing is to multiply the generator point `G` with our chosen scalar. For example, `10246385595908412093322394614482812` is the x-coordinate of `2G`.

What happens if we put a big number, such as `100000000000000000000000000000000000`? It answers with an error which tells us we chose a value bigger than the prime used in the curve. So the previous number is a possible upper bound for the prime. 

What happens if we put the previous number without a zero (`10000000000000000000000000000000000`)? It says it is good, but it is not the value which helps us to reach 1337. Than, it can viewed as a lower-bound for the prime. Moreover, it tells us the digit length of the prime.
We can also try to put `90000000000000000000000000000000000` and discover whether it is an upper bound or a lower bound. At the end it is an upper-bound.

`10000000000000000000000000000000000 < prime < 90000000000000000000000000000000000`

### 1. Finding the prime
By using the last two previous considerations, we can proceed in the following way. For each digit (from left to right) we try all the possible values until the answer from the service is `Nope` (meaning we exceed the prime). When we obtain this we know that the right digit of the prime is the last one who does not raise an error.

For example:
`00000000000000000000000000000000000`: OK
`10000000000000000000000000000000000`: OK
`20000000000000000000000000000000000`: OK
`30000000000000000000000000000000000`: OK
`40000000000000000000000000000000000`: OK
`50000000000000000000000000000000000`: OK
`60000000000000000000000000000000000`: ERROR

The first digit of the prime is: `5`
Then, we can continue:

`50000000000000000000000000000000000`: OK
`51000000000000000000000000000000000`: OK
`52000000000000000000000000000000000`: OK
`53000000000000000000000000000000000`: OK
`54000000000000000000000000000000000`: OK
`55000000000000000000000000000000000`: ERROR

The second digit is `4`
And so on...

In this way we are able to discover all the prime: `54283205379427155782089046839411711`

### Finding a and b

From this point we know only the prime and the x-coordinates of the some points. Commonly, the ECC algorithms do not exchange the entire point but only the x-coordinate. This is done in order to reducing the side channel attack surface. Of course, in order to do that, we need a way to compute points without using the y-coordinate. The Montgomery's Ladder algortihm was initially proposed for Montgomery's curves, but it was generalized in order to work also with curves in Weierstrass form. 

Given `P1` and `P2` we want to find the coordinate of `P3 = P1 + P2`:

$$x_3 = \frac{2(x_1+x_2)(x_1x_2+a)+4b}{(x_1-x_2)^2} - x_3'$$

where $$x_3'$$ is the x-coordinate of `P3' = P1 - P2`

If `P1 = P2`, then `P3 = 2 x P1` and the formula can be simplified as:

$$x_3 = \frac{(x_1^2-a)^2-8bx_1}{4(x_1^3+ax_1+b)}$$


In order to proceed we need at least two equations (remember we want to find only two parameters: a and b). 
Take the points we mentioned in the first section:
`1G = (X0, Y0) = (1, ?)`
`2G = (X1, Y1) = (10246385595908412093322394614482812, ?)`
`3G = (X2, Y2) = (39363994084598900187252501570838981, ?)`
`4G = (X3, Y3) = (21407548750102312410625794491436912, ?)`

We can write the equation for `3G = 2G + G` and put it in the form `b = something`:
$$x_2 = \frac{2(x_0+x_1)(x_0x_1+a)+4b}{(x_1-x_0)^2} - x_2'$$
$$x_2'$$ is the x-coordinate of `2G - G = G` and we know it to be $$x_0 = 1$$

The previous equations can be rewritten as:    $$b = \frac{x_2(x_1-x_0)^2 + (x_1-x_0)^2 - 2(x_0+x_1)(x_0x_1+a)}{4}$$


We can write the equation for `4G = 3G + G` and put it in the form `b = something`:
$$b = \frac{x_3(x_2-x_0)^2 + x_1(x_2-x_0)^2 - 2(x_2+x_0)(x_2x_0+a)}{4}$$
The value $x_1$ comes from the fact that we need $$x_3'$$, which is the x-coordinate of `3G - G = 2G` and we know it to be $$x_1$$.

Now, we can solve the system of equations by using `z3` or manually:
$$a = \frac{x_3(x_2-x_0)^2 + x_1(x_2-x_0)^2 - x_2(x_1-x_0)^2 - (x_1-x_0)^2 + 2x_0^2x_1 + 2x_ox_1^2 - 2x_2^2x_0 - 2x_2x_0^2}{2(x_2-x_1)}$$

Keep in mind that the division is not integer division but modular division, than multiplication by its inverse modulo the prime we found before.
From `a`, computing `b` is straightforward.

`a = 49850651047495986645822557378918223`
`b = 21049438014429831351540675253466229`

### Smart's Attack
At that point, we know the entire curve. Moreover we can find the generator `G`, which is the point with x-coordinate equal to `1`. It is very easy, we only need to compute the square root of $$1^3 + a*1 + b \mod{(prime)}$$.

Our objective is to compute the value of `k` such that the x-coordinate of `Q = kG` is equal to 1337. 
First of all we need to find `Q`. It is very easy by computing the square root of  $$1337^3 + a*1337 + b \mod{(prime)}$$.

Analyzing the prime and the curve itself we can discover what are their vulnerabilities. In particular, by checking the trace of Frobenius, which describes the size of a reduced curve, we found it is equal to `1`, meaning that we can apply the Smart's Attack to compute the discrete logarithm.

By applying the Smart Attack we found that `k = 50093393299912906873927357642002262`.

### The flag

By sending the value of k to the service we can obtain the flag: 
`flag{56c3ad9060eea4d48b9e345b9e9a666c}`

