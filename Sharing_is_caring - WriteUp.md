## SHARING IS CARING - MCH2022

### Challenge
You are supplied with 3 out of 5 points which you need to use in order to discover the secret exchanged through Shamir Secret Sharing Algorithm.

### Remarks
We know that we need at least 5 points in order to apply Lagrange and obtain the shared secret. This means that the polynomial has got the following form: $$a_0 + a_1x + a_2x^2 + a_3x^3 + a_4x^4 = y \mod{(prime)}$$
Unfortunately we don't know the prime, but they said it is of 1024 bits, then very big. 

The points we are supplied with are: 
```python
x0  = ZZ("2740898742966601935114133183106529")
y0 = ZZ("956157655799717714864508073016211621761609346753693883071835634336701162346899667843127478623689609421921959757635162027164435651849444039861798305449805669806060897098677034940051454923858123316418111771244842263136200150949")
x1 = ZZ("4681515083705154508573047498744706")
y1 = ZZ("8137729467373933116892508790883965853824225864544185629594304843306928863961691391715058478012421229999432914675335993933647800020626034683613711997688036772875553560302624022039862210798719189229119735618787699810723188634719")
x2 = ZZ("713083567420521725647105281913383")
y2 = ZZ("4380455310144784872605974709167150361708365833979536574950088299593054964905207611091625844071796262320158274849703026573280865132707680730814638177402685313693168998262565678693098484143079216308958193534983606222931969247")
```

They are in ZZ because we are dealing with integers. If we were dealing with rationals we should use `QQ`.

The maximum bit length of the `x` is 112.
The maximum bit length od the `y` is 751.

This means that with large probability the module does not interfere with the operations, which means it is never used.
This is very good because we don't know the prime, then it would be impossible to discover the secret.

### System of equations (First Technique)
Now we can write down some of the equations we know:

$$a_0 + a_1x_0 + a_2x_0^2 + a_3x_0^3 + a_4x_0^4 = y_0$$
$$a_0 + a_1x_1 + a_2x_1^2 + a_3x_1^3 + a_4x_1^4 = y_1$$
$$a_0 + a_1x_2 + a_2x_2^2 + a_3x_2^3 + a_4x_2^4 = y_2$$
$$a_0$$ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; $$= ?$$
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$$a_1$$ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; $$= ?$$
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$$a_2$$ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$$= ?$$
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$$a_3$$ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$$= ?$$
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$$a_4$$ &nbsp; &nbsp; &nbsp; $$= ?$$


You can read this system of equations in the following way: 

<img src="https://render.githubusercontent.com/render/math?math=a_0%08egin%7Bbmatrix%7D1%20%5C%201%20%5C1%20%5C%201%20%5C%200%20%5C%200%20%5C%200%20%5C%200%20end%7Bbmatrix%7D%2Ba_1%08egin%7Bbmatrix%7Dx_0%20%5C%20x_1%20%5Cx_2%20%5C%200%20%5C%201%20%5C%200%20%5C%200%20%5C%200%20end%7Bbmatrix%7D%2Ba_2%08egin%7Bbmatrix%7Dx_0%5E2%20%5C%20x_1%5E2%20%5Cx_2%5E2%20%5C%200%20%5C%200%20%5C%201%20%5C%200%20%5C%200%20end%7Bbmatrix%7D%2Ba_3%08egin%7Bbmatrix%7Dx_0%5E3%20%5C%20x_1%5E3%20%5Cx_2%5E3%20%5C%200%20%5C%200%20%5C%200%20%5C%201%20%5C%200%20end%7Bbmatrix%7D%2Ba_4%08egin%7Bbmatrix%7Dx_0%5E4%20%5C%20x_1%5E4%20%5Cx_2%5E4%20%5C%200%20%5C%200%20%5C%200%20%5C%200%20%5C%201%20end%7Bbmatrix%7D%20%3D%20%08egin%7Bbmatrix%7Dy_0%20%5C%20y_1%20%5Cy_2%20%5C%200%20%5C%200%20%5C%200%20%5C%200%20%5C%200%20end%7Bbmatrix%7D">

$$a_0\begin{bmatrix}1 \\ 1 \\1 \\ 1 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix}+a_1\begin{bmatrix}x_0 \\ x_1 \\x_2 \\ 0 \\ 1 \\ 0 \\ 0 \\ 0 \end{bmatrix}+a_2\begin{bmatrix}x_0^2 \\ x_1^2 \\x_2^2 \\ 0 \\ 0 \\ 1 \\ 0 \\ 0 \end{bmatrix}+a_3\begin{bmatrix}x_0^3 \\ x_1^3 \\x_2^3 \\ 0 \\ 0 \\ 0 \\ 1 \\ 0 \end{bmatrix}+a_4\begin{bmatrix}x_0^4 \\ x_1^4 \\x_2^4 \\ 0 \\ 0 \\ 0 \\ 0 \\ 1 \end{bmatrix} = \begin{bmatrix}y_0 \\ y_1 \\y_2 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix}$$

By transposing the vectors above we can build the target vector (to the right of the equal sign) and the lattices matrix (to the left of the equal sign). We will use the lattice base in order to compute the shortest vector in the subspace that is near to the target vector (this is the commonly known Closest Vector Problem). 
The matrix `M` will appear like that:
$$M =\begin{bmatrix} 1 & 1 & 1 & 1 & 0 & 0 & 0 & 0 \\ x_0 & x_1 & x_2 & 0 & 1 & 0 & 0 & 0 \\ x_0^2 & x_1^2 & x_2^2 & 0 & 0 & 1 & 0 & 0 \\ x_0^3 & x_1^3 & x_2^3 & 0 & 0 & 0 & 1 & 0\\  x_0^4 & x_1^4 & x_2^4 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}$$

And the target vector is: $$t = \begin{bmatrix}y_0 & y_1 & y_2 & 0 & 0 & 0 & 0 & 0 \end{bmatrix}$$

In practice we are searching for the vector `S` of dimension 5 such that `S x M` is close to `t`.

Now, there is only one issue to solve. Because we are dealing with huge numbers in the target vector, we will obtain a vector whos values are very big and they are not the lowest possible values for that vector. That means the length of our target vector is really big and there are lots of vectors that are relatively close to it. If our target vector was smaller, our chance of finding it exactly would be much higher. What can we do? We will use the scaling technique: we will divide our predictions (the diagonal 1s in the matrix `M`) by a scale factor (which has to be very big, more or less $$2^150$$). Call this value `D`.

The matrix will become: 
$$M =\begin{bmatrix} 1 & 1 & 1 & 1/D & 0 & 0 & 0 & 0 \\ x_0 & x_1 & x_2 & 0 & 1/D & 0 & 0 & 0 \\ x_0^2 & x_1^2 & x_2^2 & 0 & 0 & 1/D & 0 & 0 \\ x_0^3 & x_1^3 & x_2^3 & 0 & 0 & 0 & 1/D & 0\\  x_0^4 & x_1^4 & x_2^4 & 0 & 0 & 0 & 0 & 1/D \end{bmatrix}$$
At the end, the result must be rescaled up, which means multiplied by `D`.

The same result can be obtained by multiplying the coefficients instead of dividing the 1s:
The matrix `M` will appear like that:
$$M =\begin{bmatrix} D*1 & D*1 & D*1 & 1 & 0 & 0 & 0 & 0 \\ D*x_0 & D*x_1 & D*x_2 & 0 & 1 & 0 & 0 & 0 \\ D*x_0^2 & D*x_1^2 & D*x_2^2 & 0 & 0 & 1 & 0 & 0 \\ D*x_0^3 & D*x_1^3 & D*x_2^3 & 0 & 0 & 0 & 1 & 0\\  D*x_0^4 & D*x_1^4 & D*x_2^4 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}$$

And the target vector is: $$t = \begin{bmatrix}D*y_0 & D*y_1 & D*y_2 & 0 & 0 & 0 & 0 & 0 \end{bmatrix}$$

Know we need to solve the CVP and rescale the result. The value of the matrix corresponding to $$a_0$$ will be our solution. 
A simple `long_to_bytes` will transform it to the flag.

### System of equations (Second Technique)
We can use a modified system of equation:
$$a_0 + a_1x_0 + a_2x_0^2 + a_3x_0^3 + a_4x_0^4 - y_0 = 0$$
$$a_0 + a_1x_1 + a_2x_1^2 + a_3x_1^3 + a_4x_1^4 - y_1 = 0$$
$$a_0 + a_1x_2 + a_2x_2^2 + a_3x_2^3 + a_4x_2^4 - y_2 = 0$$
$$a_0$$ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;$$= ?$$
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$$a_1$$ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;$$= ?$$
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$$a_2$$ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;$$= ?$$
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$$a_3$$&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;$$= ?$$
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$$a_4$$ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;$$= ?$$

which is: 

$$a_0\begin{bmatrix}1 \\ 1 \\1 \\ 1 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix}+a_1\begin{bmatrix}x_0 \\ x_1 \\x_2 \\ 0 \\ 1 \\ 0 \\ 0 \\ 0 \end{bmatrix}+a_2\begin{bmatrix}x_0^2 \\ x_1^2 \\x_2^2 \\ 0 \\ 0 \\ 1 \\ 0 \\ 0 \end{bmatrix}+a_3\begin{bmatrix}x_0^3 \\ x_1^3 \\x_2^3 \\ 0 \\ 0 \\ 0 \\ 1 \\ 0 \end{bmatrix}+a_4\begin{bmatrix}x_0^4 \\ x_1^4 \\x_2^4 \\ 0 \\ 0 \\ 0 \\ 0 \\ 1 \end{bmatrix} - \begin{bmatrix}y_0 \\ y_1 \\y_2 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix} = \begin{bmatrix}0 \\ 0 \\0 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix}$$

The matrix will appear like that:
$$M =\begin{bmatrix} 1 & 1 & 1 & 1 & 0 & 0 & 0 & 0 & 0\\ x_0 & x_1 & x_2 & 0 & 1 & 0 & 0 & 0 & 0\\ x_0^2 & x_1^2 & x_2^2 & 0 & 0 & 1 & 0 & 0 & 0\\ x_0^3 & x_1^3 & x_2^3 & 0 & 0 & 0 & 1 & 0 & 0\\  x_0^4 & x_1^4 & x_2^4 & 0 & 0 & 0 & 0 & 1 & 0\\ -y_0 & -y_1 & -y_2 & 0 & 0 & 0 & 0 & 0 & 1\end{bmatrix}$$

As before, it needs to be scaled in order to retrive the right vector (by dividing the 1s in the diagonal or multiplying the coeffiecients for the factor `D`).
This matrix can be used in SageMath and we can call the `LLL()` algorithm on it.

### Important
When we scale the 1s in the diagonal, we are obliged to rescale up the values at the end of the computation. The right part of the matrix (the one with the diagonal 1s) can be viewed as the "container" of the results. 

On the other hand, when we multiply the coefficients we don't need to rescale the result because we didn't modify the "container", but only the known values. 

### The code

Within the code you can find both the techniques.

### The flag

Use `long_to_bytes` in order to trasform the secret in the flag:
`flag{a729a11d2dc62daa300a8b9623057e44}`

