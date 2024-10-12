import functools



def admt_command():
    def decorator(f):
        @functools.wraps(f)
        def wrapper(*args, **kwargs):
            # todo: log function call to history file?
            res = f(*args, **kwargs)
            return res
        return wrapper
    return decorator
