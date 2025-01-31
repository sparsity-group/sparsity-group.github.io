---
layout: distill
title: Surprising Properties of Two-Hidden Layer Neural Networks
date: 2020-08-21
tags: neural-networks statistical-learning approximation-theory
related_posts: false

bibliography: 2020-08-21-surprising-properties-two-hidden-layer-neural-networks.bib

authors:
  - name: Rahul Parhi
    affiliations:
      name: University of Wisconsin--Madison
---

## Introduction

Neural networks, particularly _deep_ neural networks, are extremely popular in
modern machine learning due to their seemingly "magical" properties. The usual
heuristic for explaining why neural networks work is that they are _universal
approximators_, though we remark that universal approximation is a rather boring
result and is easily achieved by any sufficiently nice class of functions. For
more information why universal approximation is rather boring, see the entire
field of approximation theory.

The well-known universal approximation theorem has been studied by a number of
authors and considers single-hidden layer neural networks of the form

$$
    \mathbf{x} \mapsto \sum_{k=1}^K v_k \, \rho(\mathbf{w}_k^\mathsf{T} \mathbf{x} -
    b_k),
    \tag{1}
$$

<!-- prettier-ignore -->
where \\(\rho: \mathbb{R} \to \mathbb{R}\\) is a fixed _activation function_
and, for \\(k = 1, \ldots K\\), \\(v_k \in \mathbb{R}\\) and \\(\mathbf{w}\_k
\in \mathbb{R}^d\\) are the *weights* of the network and \\(b_k \in
\mathbb{R}\\) are the *biases* of the network. The universal approximation
theorem then says that just about any choice of activation function \\(\rho\\),
one can _uniformly_ approximate arbitrarily well any given continuous function
with functions of the form in \\((1)\\). It is important to note that this
result does not assume that the width \\(K\\) is fixed, i.e., \\(K\\) can be
(and must be) arbitrarily large. In other words, there does not exist a fixed
\\(K\\) such that every continuous function can be uniformly approximated by
functions of the form in \\((1)\\). In fact, the universal approximation
property cannot hold if \\(K\\) is fixed, even if we allow \\(\rho\\) to be
tunable over all continuous functions. This fundamental fact regarding
single-hidden layer networks can be seen in Theorem 5.1 of <d-cite
key="lin1993fundamentality"></d-cite>.

What is surprising is that this negative property of single-hidden layer neural
networks does not carry over to the two-hidden layer case. Indeed, with
two-hidden layers, there exists an activation function \\(\rho\\) and a network
width proportional to the input dimension such that any continuous function
defined on a compact domain can be uniformly approximated by a two-hidden layer
network of this width.

This result was proved in Theorem 5 of <d-cite key="maiorov1999lower"></d-cite>.
In this post we will prove this result and discuss its implications to
statistical learning. In particular, we will use this result to show that there
exist finite-parameter neural networks with infinite [Vapnik--Chervonenkis (VC)
dimension](https://en.wikipedia.org/wiki/Vapnik%E2%80%93Chervonenkis_dimension).
This result provides a new example to the well-known fact that the VC-dimension
of a parameterized hypothesis space is not upper-bounded by the dimension of the
parameter space.

## Universal approximation

The most general version of the universal approximation theorem is due to
Leshno, Lin, Pinkus, and Schocken in 1993<d-cite
key="leshno1993multilayer"></d-cite>.

**Proposition 1 (Theorem 1 of <d-cite key="leshno1993multilayer"></d-cite>).**
Let \\(\rho: \mathbb{R} \to \mathbb{R}\\) be any continuous function and let
\\(\Omega \subset \mathbb{R}^d\\) be compact. Then, the set

$$
  \mathsf{1NN}_\rho := \textrm{span}\{\mathbf{x} \mapsto
  \rho(\mathbf{w}^\mathsf{T} \mathbf{x} - b) \: : \: \mathbf{w} \in
  \mathbb{R}^d, b \in \mathbb{R}\}
$$

is dense (with respect to the uniform norm) in \\(C(\Omega)\\), the space of
continuous functions on \\(\Omega\\), if and only if \\(\rho\\) is not an algebraic
polynomial.

As discussed in the [Introduction](#introduction), Theorem 5.1 of <d-cite
key="lin1993fundamentality"></d-cite> says that if we
let \\(K \in \mathbb{N}\\) be fixed and consider the set

$$
  \mathsf{1NN}_\rho^K := \left\{ \mathbf{x} \mapsto \sum_{k=1}^K v_k
  \, \rho(\mathbf{w}_k^\mathsf{T} \mathbf{x} - b_k) \: : \: v_k \in \mathbb{R},
  \mathbf{w}_k \in \mathbb{R}^d, b_k \in \mathbb{R} \right\}
$$

or the set

$$
  \mathsf{1NN}^K := \left\{ \mathbf{x} \mapsto \sum_{k=1}^K v_k \,
  \rho(\mathbf{w}_k^\mathsf{T} \mathbf{x} - b_k) \: : \: v_k \in \mathbb{R},
  \mathbf{w}_k \in \mathbb{R}^d, b_k \in \mathbb{R}, \rho \in C(\mathbb{R})
  \right\},
$$

then, neither \\(\mathsf{1NN}\_\rho^K\\) nor \\(\mathsf{1NN}^K\\) is dense in
\\(C(\Omega)\\), where \\(\Omega \subset \mathbb{R}^d\\) is compact.

Theorem 5 of <d-cite key="maiorov1999lower"></d-cite> considers the
set of two-hidden layer neural networks with fixed hidden layer widths

$$
  \mathsf{2NN}_\rho^{K_1, K_2} := \left\{\mathbf{x} \mapsto
  \sum_{k=1}^{K_2} u_k \rho\left(\sum_{\ell = 1}^{K_1} v_{k\ell}\,
  \rho(\mathbf{w}_{k\ell}^\mathsf{T}\mathbf{x}
  - b_{k\ell}) - c_k\right) \: : \: u_k \in \mathbb{R}, v_{k\ell} \in \mathbb{R},
    \mathbf{w}_{k\ell} \in \mathbb{R}^d, b_{k\ell} \in \mathbb{R}, c_k \in \mathbb{R}\right\}.
$$

<!-- prettier-ignore -->
In particular, \\(K_1\\) and \\(K_2\\) are both \\(O(d)\\). The main idea is
that \\(\rho\\) in the above display is a specially constructed activation
function. Theorem 5 of <d-cite key="maiorov1999lower"></d-cite> then says
\\(\mathsf{2NN}_\rho^{K_1, K_2}\\) is dense in \\(C(\Omega)\\). Before proving
this result, we remark that there are two key ingredients to the proof. The
first is the seperability of the metric space \\(C(\Omega)\\) when equipped with
the uniform norm as the metric. The second is the Kolmogorov superposition
theorem<d-cite key="kolmogorov1956representation"></d-cite>. We will first
recall this theorem.

**Proposition 2 (Kolmogorov Superposition Theorem<d-cite key="kolmogorov1956representation"></d-cite>).**
Let \\(d \geq 2\\). Then, there exist constants \\(\lambda_q > 0\\), \\(q = 1,
\ldots, d\\), and continuous functions \\(\phi_q: [0, 1] \to [0, 1]\\), \\(p =
1, \ldots, 2d + 1\\), such that every continuous function \\(f: [0, 1]^d \mapsto
\mathbb{R}\\) admits the representation

$$
    f(\mathbf{x}) = f(x_1, \ldots, x_d) = \sum_{p=1}^{2d + 1} g
    \left(\sum_{q=1}^d \lambda_q \phi_q(x_q)\right),
    \tag{2}
$$

for some \\(g \in C[0, 1]\\) depending on \\(f\\).

We will now prove the main result.

**Theorem 1 (Similar to Theorem 5 of <d-cite key="maiorov1999lower"></d-cite>).** Let
\\(\Omega \subset \mathbb{R}^d\\) be compact. There exists \\(K_1\\) and \\(K_2\\) being
\\(O(d)\\) and \\(\rho: \mathbb{R} \to \mathbb{R}\\) such that \\(\mathsf{2NN}\_\rho^{K_1,
K_2}\\) is dense (with respect to the uniform norm) in \\(C(\Omega)\\). In other
words, given \\(\varepsilon > 0\\), for every \\(f \in C(\Omega)\\), there exists a
two-hidden layer neural network \\(h \in \mathsf{2NN}\_\rho^{K_1, K_2}\\) such that

$$
    \lVert f - h \rVert_{L^\infty(\Omega)} < \varepsilon
$$

In particular, \\(K_1 = d\\) and \\(K_2 = 2d + 1\\).

_Proof._ It suffices to prove the result for \\(\Omega = [0,1]^d\\) since the
general result then follows by translating and dilating. The main idea is to
construct \\(\rho\\) in a special manner so that there exist weights and biases so
that the terms that appear in the Kolmogorov superposition theorem in \\((2)\\) can
be uniformly approximated by the activation function. The construction relies on
the fact that \\(C[0,1]\\) is seperable. Indeed, let \\(\{p*n\}*{n \in \mathbb{Z}}\\)
be an enumeration of any countable dense subset of \\(C[0,1]\\), say, polynomials
with rational coefficients. Then, define \\(\rho\\) so that for every \\(n \in
\mathbb{Z}\\),

$$
    \rho(x) = p_n(x - n), \quad x \in [n, n + 1]
$$

i.e., on each interval \\([n, n + 1]\\), \\(\rho\\) is a polynomial with rational
coefficients. The main idea with this construction is that we have "encoded"
every single polynomial with rational coefficients within \\(\rho\\).

The theorem follows immediately by invoking the Kolmogorov superposition
theorem. Indeed, since we are restricting ourselves to \\([0,1]^d\\), we can
uniformly approximate every function that appears in \\((2)\\) with \\(\rho\\) with
appropriate weights and biases. \\(\square\\)

<!-- prettier-ignore -->
While the activation function constructed in the above proof doesn't have many
nice properties, activation functions that achieve the same result can be
constructed with more complex constructions that are real analytic, strictly
increasing, and sigmoidal (in the sense that \\(\lim_{x \to -\infty} \rho(x) =
0\\) and \\(\lim_{x \to \infty} \rho(x) = 1\\)). For such a construction, we
refer the reader to Section 2 of <d-cite key="maiorov1999lower"></d-cite>. We
additionally remark that in this more complicated construction, the main idea of
encoding every single polynomial with rational coefficients within the
activation function remains. Another similar construction appears in Theorem
5.10 of <d-cite key="ismailov2020notes"></d-cite>.

## Implications to statistical learning

We will now recall the usual example of a finite-parameter hypothesis space with
infinite VC dimension. Consider set of (one-dimensional) classifiers

$$
    \mathcal{F} := \{f_\theta \: : \: f_\theta(x) = \mathrm{sgn}(\sin(\theta x))\}.
$$

It's easy to verify that \\(\mathcal{F}\\) can shatter any data set, and so
\\(\mathcal{F}\\) has infinite VC dimension, yet the classifiers are parameterized
by a single real number. The main drawback of this example is that it only
works for one-dimensional data sets.

With Theorem 1 in hand, we can now state a new example of a parameterized
hypothesis space whose VC dimension is infinite, although the dimension of the
parameter space is finite. In particular, the example we will construct applies
to data sets of any dimension. Moreoever, the dimension of the parameter space
is proportional to the dimension of the data set.

Consider any data set \\( \\{ (\mathbf{x}\_n, y_n) \\}\_{n=1}^N \subset \mathbb{R}^d \times
\\{-1, +1\\} \\) where \\(\Omega \subset \mathbb{R}^d\\) is compact. Clearly any such
data set can be shattered by

$$
    \{ \tilde{f} \: : \: \tilde{f} = \mathrm{sgn}(f), f \in
    C(\mathcal{CH}(\{\mathbf{x}_n\}_{n=1}^N)) \}
$$

where \\(\mathcal{CH}(\cdot)\\) is the convex hull and
\\( C(\mathcal{CH}(\\{\mathbf{x}\_n\\}\_{n=1}^N)) \\) is the space of continuous functions
defined on the convex hull of \\(\\{\mathbf{x}\_n\\}\_{n=1}^N\\). The argument is to
choose \\(f\\) so that \\(f\\) interpolates the data set (choose your favorite spline).
Next, since \\(\mathcal{CH}(\\{\mathbf{x}\_n\\}\_{n=1}^N)\\) is compact, by Theorem 1 we
know that there exists a two-hidden layer neural network that is
\\(\varepsilon\\)
close at every input (at least on \\(\mathcal{CH}(\\{\mathbf{x}\_n\\}\_{n=1}^N)\\),
which is all that matters for the sake of the argument), for any \\(\varepsilon >
0\\). This means the set

$$
    \{ \tilde{f} \: : \: \tilde{f} = \mathrm{sgn}(f), f \in
    \mathsf{2NN}_\rho^{K_1, K_2} \}
$$

with \\(K_1\\), \\(K_2\\), and \\(\rho\\) as in Theorem 1 also shatters every data set. Thus
we see that two-hidden layer neural networks with \\(O(d)\\) width and a specially
chosen activation function have infinite VC dimension.

While this result may seem contradictory, since there are many results regarding
the VC dimension of neural networks that would say otherwise, there is no
contradiction since the networks considered in the above example have a
specially chosen activation function. Indeed, it's easy to verify that the set
of classifiers defined by \\(x \mapsto \mathrm{sgn}(\rho(wx - b))\\) can shatter any
one-dimensional dataset for appropriate choice of \\(w, b \in \mathbb{R}\\).

## Takeaway messages

- Function compositions provide the ability to approximate or represent many
  functions with only few parameters, as evidenced by the Kolmogorov
  superposition theorem. This is perhaps a heuristic for explaining why depth
  matters in neural networks.

- When discussing VC dimension of neural networks, it is important to discuss
  the VC dimension of the activation function itself. Indeed, the only reason the
  argument in [Implications to statistical
  learning](#implications-to-statistical-learning) follows is because the VC
  dimension of the activation function is itself infinite.

- There is a large gap between the capabilities of single-hidden layer and
  two-hidden layer neural networks, and this gap is still not very well
  understood.
