! This demonstrates the testing of the adjoint of "eval" (which computes the vector magnitude).
! To generate and test the adjoint, the tangent of the primal is required and needs testing first.

program main
  implicit none
  real(8),parameter::eps = 0.000001

  real(8),dimension(3)::x
  real(8),dimension(3)::x_dif
  real(8),dimension(3)::x_tng
  real(8),dimension(3)::x_adj

  real(8)::f
  real(8)::f_dif
  real(8)::f_tng
  real(8)::f_adj

  print *, "primal test"
  call random_number(x)
  call eval(x, f)
  print *, "  via primal function  ", f

  x_tng = 0
  call eval_tng(x_tng, x, f_tng, f)
  print *, "  via tangent function ", f

  f_adj = 0
  x_adj = 0
  call eval_adj(x_adj, x, f_adj, f)
  print *, "  via adjoint function ", f


  print *, "derivative test"
  call random_number(x_dif)
  call eval_dif(x, x_dif, f_dif, eps)
  print *, "  via primal function  ", f_dif

  x_tng = x_dif
  call eval_tng(x_tng, x, f_tng, f)
  print *, "  via tangent function ", f_tng


  print *, "dot product test"
  call random_number(x_tng)
  call eval_tng(x_tng, x, f_tng, f)

  call random_number(f_adj)
  x_adj = 0
  print *, "  lhs product ", f_adj * f_tng

  call eval_adj(x_adj, x, f_adj, f)
  print *, "  rhs product ", dot_product(x_adj, x_tng)

contains

  subroutine eval(x, f)
    implicit none
    integer::i
    real(8),dimension(:)::x
    real(8)::f
    f = 0
    do i = 1, size(x)
       f = f + x(i)**2
    end do
    f = sqrt(f)
  end subroutine eval


  subroutine eval_dif(x, x_dif, f_dif, eps)
    implicit none
    real(8)::eps
    real(8),dimension(:)::x
    real(8),dimension(:)::x_dif
    real(8)::f
    real(8)::f_dif
    call eval(x, f)
    call eval(x + x_dif * eps, f_dif)
    f_dif = (f_dif - f) / eps
  end subroutine eval_dif


  subroutine eval_tng(x_tng, x, f_tng, f)
    implicit none
    integer::i
    real(8),dimension(:)::x_tng
    real(8),dimension(:)::x
    real(8)::f_tng
    real(8)::f
    f_tng = 0
    f = 0
    do i = 1, size(x)
       f_tng = f_tng + (2 * x(i)) * x_tng(i)
       f = f + x(i)**2
    end do
    f_tng = f_tng / (2 * sqrt(f))
    f = sqrt(f)
  end subroutine eval_tng


  subroutine eval_adj(x_adj, x, f_adj, f)
    implicit none
    integer::i
    real(8),dimension(:)::x_adj
    real(8),dimension(:)::x
    real(8)::f_adj
    real(8)::f
    f = 0
    do i = 1, size(x)
       f = f + x(i)**2
    end do

    f_adj = f_adj / (2 * sqrt(f))
    f = sqrt(f)

    do i = 1, size(x)
       x_adj(i) = x_adj(i) + (2 * x(i)) * f_adj
    end do
    f_adj = 0
  end subroutine eval_adj
end program main
