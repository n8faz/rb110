# What does shift do in the following code? How can we find out?

hash = { a: 'ant', b: 'bear' }
hash.shift

# Shift removes the first hash entry from the hash object it is called on. In this case, the element a: 'ant' is removed from the object, so the return will be the hash object containing one key value pair { b: 'bear'}. This is a destructive method. We can find this out by reading the ruby documentation on the method, and also just testing the code.
