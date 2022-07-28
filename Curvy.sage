from sage.all import *
from pwn import *

context.log_level = "error"


def SmartAttack(P,Q,p):
    E = P.curve()
    Eqp = EllipticCurve(Qp(p, 2), [ ZZ(t) + randint(0,p)*p for t in E.a_invariants() ])

    P_Qps = Eqp.lift_x(ZZ(P.xy()[0]), all=True)
    for P_Qp in P_Qps:
        if GF(p)(P_Qp.xy()[1]) == P.xy()[1]:
            break

    Q_Qps = Eqp.lift_x(ZZ(Q.xy()[0]), all=True)
    for Q_Qp in Q_Qps:
        if GF(p)(Q_Qp.xy()[1]) == Q.xy()[1]:
            break

    p_times_P = p*P_Qp
    p_times_Q = p*Q_Qp

    x_P,y_P = p_times_P.xy()
    x_Q,y_Q = p_times_Q.xy()

    phi_P = -(x_P/y_P)
    phi_Q = -(x_Q/y_Q)
    k = phi_Q/phi_P
    return ZZ(k)



"""
    Finding the prime
"""
prime = "00000000000000000000000000000000000"
length = 35
indice = 0

while not is_prime(int(prime)):
    if indice < 35:
        for c in "0123456789":
            r = remote("curvy.ctf.zone", 6011) # connection
            r.recvuntil("\n")
            primo = prime[:indice] + str(c) + prime[indice+1:]
            r.sendline(primo)
            res = r.recvuntil("\n")
            if b'Nope' in res:
                prime = primo
            if b'Sorry' in res:
                break
        indice = indice + 1
    else:
        break

    
print(f'The prime is: {prime}')

# prime = 54283205379427155782089046839411711


"""
    Finding a and b
"""

# Computes the square roots of the value a given the prime m
def square_roots(a, m):
  s = pow(a, (m + 1) / 4, m)
  return s, m - s

# the points we need for the equations
x0 = 1
x1 = 10246385595908412093322394614482812
x2 = 39363994084598900187252501570838981
x3 = 21407548750102312410625794491436912

den = (2*x2 - 2*x1) % prime
den = inverse_mod(den, prime)

numerator = ( x3*((x2-x0)^2) + x1*((x2-x0)^2) +2*x1*(x0^2) + 2*x0*(x1^2) -2*x0*(x2^2) -2*x2*(x0^2) -x2*((x1-x0)^2) - (x1-x0)^2 ) % prime
a = (numerator * den) % prime

print(f'The value of a is: {a}')


den2 = inverse_mod(4, prime)
numerator2 = (x2*((x1-x0)^2) + (x1-x0)^2 - 2*(x1+x0)*(x0*x1+int(a))) % prime
b = (numerator2 * den2) % prime

print(f'The value of b is: {b}')


# Generaring the curve
F = GF(prime)
E = EllipticCurve(F, [a,b])

# Finding the generator G
y_square = x0*x0*x0 + a*x0 + b % prime
y0_vals = square_roots(y_square, prime)
G = E(x0, y0_vals[0])


x_target = 1337
y_square_target = x_target*x_target*x_target + a*x_target + b % prime
y_target_vals = square_roots(y_square_target, prime)
y_target = y_target_vals[1]
Q = E(x_target,y_target)

# Checking if we can apply Smart's Attack
if (E.trace_of_frobenius() == 1):
    print("We can apply Smart's Attack")
    k_secret = SmartAttack(G,Q,prime)
    print(f'The value of k is: {k_secret}')

