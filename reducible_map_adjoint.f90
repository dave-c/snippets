program main
  real,dimension(2)::map_adj = (/0.0, 1.0/)
  real,dimension(2)::map = (/2.0, 0.0/)

  call eval(1, 2)
  print *, map(2)

  call eval_adj(1, 2)
  print *, map_adj(1)

contains

  subroutine eval(k1, k2)
    real x, y
    call get(k1, x)
    y = x * x
    call insert(k2, y)
  end subroutine eval

  subroutine insert(key, val)
    integer::key
    real::val
    map(key) = val
  end subroutine insert

  subroutine get(key, val)
    integer::key
    real::val
    val = map(key)
  end subroutine get


  subroutine eval_adj(k1, k2)
    implicit none
    real :: x, y
    real :: x_adj, y_adj
    integer :: k1
    integer :: k2
    call get(k1, x)
    call insert_adj(k2, y, y_adj)
    x_adj = 2*x*y_adj
    call get_adj(k1, x, x_adj)
  end subroutine eval_adj

  subroutine insert_adj(key, val, val_adj)
    implicit none
    integer :: key
    real :: val
    real :: val_adj
    val_adj = map_adj(key)
    map_adj(key) = 0.0
  end subroutine insert_adj

  subroutine get_adj(key, val, val_adj)
    implicit none
    integer :: key
    real :: val
    real :: val_adj
    map_adj(key) = map_adj(key) + val_adj
  end subroutine get_adj
end program main
