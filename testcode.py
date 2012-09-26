# Code to be dissected

def fib(n):
    """Return the nth fibonacci number."""
    a, b = 0, 1
    while b < n:
        a, b = b, a + b
    return b

def bar(n):
    ' '.join(map(str, range(n)))
