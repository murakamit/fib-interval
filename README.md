FibInterval
===========

Keywords
--------

* backup
* thin out
* variable intervals
  * sparse for old, dense for new
  * fibonacci sequence

Description
-----------

`FibInterval` indicates the file to be deleted at overflow.  
It makes variable Intervals between the files to be sparse for old, dense for new.

Usage
-----

`FibInterval` considers list.first as oldest, list.last as newest.  
You must get intervals before you call `FibInterval.index_to_delete`.  
For example,

    def get_intervals(list)
      result = []
      prev = nil
      list.each { |x|
        result << (x - prev) if prev
        prev = x
      }
      result
    end

`FibInterval.index_to_delete` returns an index(belongs to *list*).

    list = [1, 2, 3, 4, 5]
    intervals = get_intervals list # => [1, 1, 1, 1]
    i = FibInterval.index_to_delete intervals # => 1
    list.delete_at i # list => [1, 3, 4, 5], intervals => [2, 1, 1]

Example
-------

    (intervals) [list] <- next

`*` points delete target.

    $ ruby usage-examples/00_step-by-step.rb 5 20
    fibs = 1, 2, 3, 5
    1 + 2 + 3 + 5 = 11
    list_maxsize = 5
    20 steps
    () [] <- 1
    () [  1] <- 2
    (  1) [  1,   2] <- 3
    (  1,   1) [  1,   2,   3] <- 4
    (  1,   1,   1) [  1,   2,   3,   4] <- 5
    (  1,   1,   1,   1) [  1,  *2,   3,   4,   5] <- 6
    (  2,   1,   1,   1) [  1,  *3,   4,   5,   6] <- 7
    (  3,   1,   1,   1) [  1,   4,  *5,   6,   7] <- 8
    (  3,   2,   1,   1) [  1,  *4,   6,   7,   8] <- 9
    (  5,   1,   1,   1) [  1,   6,  *7,   8,   9] <- 10
    (  5,   2,   1,   1) [  1,   6,  *8,   9,  10] <- 11
    (  5,   3,   1,   1) [  1,   6,   9, *10,  11] <- 12
    (  5,   3,   2,   1) [ *1,   6,   9,  11,  12] <- 13
    (  3,   2,   1,   1) [  6,  *9,  11,  12,  13] <- 14
    (  5,   1,   1,   1) [  6,  11, *12,  13,  14] <- 15
    (  5,   2,   1,   1) [  6,  11, *13,  14,  15] <- 16
    (  5,   3,   1,   1) [  6,  11,  14, *15,  16] <- 17
    (  5,   3,   2,   1) [ *6,  11,  14,  16,  17] <- 18
    (  3,   2,   1,   1) [ 11, *14,  16,  17,  18] <- 19
    (  5,   1,   1,   1) [ 11,  16, *17,  18,  19] <- 20

- - - - - - - - - - - - - - - - - - - -
Author: MURAKAMI Teiji  
GitHub: https://github.com/murakamit  
