! Demonstrate the testing of the adjoint of "eval"
!
! To generate and test the adjoint, the tangent of the primal is written and tested
! against a finite-difference derivative via invocations of primal,
! then once the tangent is tested the adjoint is implemented and tested against the tangent.

program main
  implicit none
  real(8),parameter::eps = 0.000001

  real(8),dimension(3)::x
  real(8),dimension(3)::x_dif
  real(8),dimension(3)::x_tng
  real(8),dimension(3)::x_adj

  real(8)::y
  real(8)::y_dif
  real(8)::y_tng
  real(8)::y_adj

  real(8)::f
  real(8)::f_dif
  real(8)::f_tng
  real(8)::f_adj

  real(8),dimension(3)::g
  real(8),dimension(3)::g_dif
  real(8),dimension(3)::g_tng
  real(8),dimension(3)::g_adj


  print *, "primal test:"
  call random_number(x)
  call random_number(y)
  call eval(x, y, f, g)
  print *, "  via primal  function ", f, g

  x_tng = 0
  y_tng = 0
  call eval_tng(x_tng, x, y_tng, y, f_tng, f, g_tng, g)
  print *, "  via tangent function ", f, g

  f_adj = 0
  g_adj = 0
  call eval_adj(x_adj, x, y_adj, y, f_adj, f, g_adj, g)
  print *, "  via adjoint function ", f, g


  print *, "derivative test:"
  call random_number(x_dif)
  call random_number(y_dif)
  call eval_dif(x, x_dif, y, y_dif, f_dif, g_dif, eps)
  print *, "  via primal  function ", f_dif, g_dif

  x_tng = x_dif
  y_tng = y_dif
  call eval_tng(x_tng, x, y_tng, y, f_tng, f, g_tng, g)
  print *, "  via tangent function ", f_tng, g_tng


  print *, "dot-product test:"
  call random_number(x_tng)
  call random_number(y_tng)
  call eval_tng(x_tng, x, y_tng, y, f_tng, f, g_tng, g)

  call random_number(f_adj)
  call random_number(g_adj)
  x_adj = 0
  y_adj = 0
  print *, "  outputs sum ", f_adj * f_tng + dot_product(g_adj, g_tng)

  call eval_adj(x_adj, x, y_adj, y, f_adj, f, g_adj, g)
  print *, "  inputs  sum ", dot_product(x_adj, x_tng) + y_adj * y_tng

contains

  subroutine eval(x, y, f, g)
    implicit none
    integer::i
    real(8)::u
    real(8),dimension(:)::x
    real(8)::y
    real(8)::f
    real(8),dimension(:)::g
    f = 0
    do i = 1, size(x)
       u = x(i) * y
       f = f + u**2
    end do
    f = sqrt(f)
    g = f / x
  end subroutine eval


  subroutine eval_dif(x, x_drv, y, y_drv, f_drv, g_drv, eps)
    implicit none
    real(8)::eps
    real(8),dimension(:)::x
    real(8),dimension(:)::x_drv
    real(8)::y
    real(8)::y_drv
    real(8)::f_drv
    real(8),dimension(:)::g_drv
    call eval(x, y, f, g)
    call eval(x + x_drv * eps, y + y_drv * eps, f_drv, g_drv)
    f_drv = (f_drv - f) / eps
    g_drv = (g_drv - g) / eps
  end subroutine eval_dif


  subroutine eval_tng(x_drv, x, y_drv, y, f_drv, f, g_drv, g)
    implicit none
    integer::i
    real(8)::u_drv
    real(8)::u
    real(8),dimension(:)::x_drv
    real(8),dimension(:)::x
    real(8)::y_drv
    real(8)::y
    real(8)::f_drv
    real(8)::f
    real(8),dimension(:)::g_drv
    real(8),dimension(:)::g
    f_drv = 0
    f = 0
    do i = 1, size(x)
       u_drv = x_drv(i) * y + x(i) * y_drv
       u = x(i) * y
       f_drv = f_drv + (2 * u) * u_drv
       f = f + u**2
    end do
    f_drv = f_drv / (2 * sqrt(f))
    f = sqrt(f)
    g_drv = f_drv / x - (f / x**2) * x_drv
    g = f / x
  end subroutine eval_tng


  subroutine eval_adj(x_drv, x, y_drv, y, f_drv, f, g_drv, g)
    implicit none
    integer::i
    real(8)::u_drv
    real(8)::u
    real(8),dimension(:)::x_drv
    real(8),dimension(:)::x
    real(8)::y_drv
    real(8)::y
    real(8)::f_drv
    real(8)::f
    real(8),dimension(:)::g_drv
    real(8),dimension(:)::g
    f = 0
    do i = 1, size(x)
       u = x(i) * y
       f = f + u**2
    end do

    f = sqrt(f)

    f_drv = f_drv + dot_product(1 / x, g_drv)
    x_drv = x_drv - (f / x**2) * g_drv
    g = f / x

    f = 0
    do i = 1, size(x)
       u = x(i) * y
       f = f + u**2
    end do

    f_drv = f_drv / (2 * sqrt(f))
    f = sqrt(f)

    do i = 1, size(x)
       u_drv = 0
       u = x(i) * y

       u_drv = u_drv + (2 * u) * f_drv

       x_drv(i) = x_drv(i) + y * u_drv
       y_drv = y_drv + x(i) * u_drv
    end do

    f_drv = 0
    g_drv = 0
  end subroutine eval_adj
end program main
