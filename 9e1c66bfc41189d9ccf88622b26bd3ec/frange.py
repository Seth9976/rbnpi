#python3 version (same as python2 version)
#analog of the range() function but this one allows decimal increments
def frange(start, end, step=None):
    if step!=None:
        this = start
        list = []
        list.append(this)
        while (this <= end):
            this = this + step
            this = round(this, 2)
            list.append(this)
        return list