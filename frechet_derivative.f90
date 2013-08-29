! demonstrate Frechet derivatives
! \lim_{\tau \to 0} \frac{f(x_0 + \tau v) - f(x_0)}{\tau} = f'(x_0) v

program main
  implicit none
  real(8),dimension(3)::x_dif
  real(8),dimension(3)::x_tng
  real(8),dimension(3)::x
  real(8)::f_dif
  real(8)::f_tng
  real(8)::f

  call random_number(x)
  call eval(x, f)
  print *, f

  call eval_dif(x, x_dif, f_dif)
  print *, f_dif

  x_tng = x_dif
  call eval_tng(x_tng, x, f_tng, f)
  print *, f_tng, f

contains

  subroutine eval(x, f)
    implicit none
    real(8),dimension(:)::x
    real(8)::f
    integer::i
    f = 0
    do i = 1, size(x)
       f = f + x(i)**2
    end do
    f = sqrt(f)
  end subroutine eval


  subroutine eval_dif(x, x_dif, f_dif)
    implicit none
    real(8),dimension(:)::x
    real(8),dimension(:)::x_dif
    real(8)::f
    real(8)::f_dif
    real(8),parameter::eps = 0.000001
    call random_number(x_dif)
    call eval(x, f)
    call eval(x + x_dif * eps, f_dif)
    f_dif = (f_dif - f) / eps
  end subroutine eval_dif


  subroutine eval_tng(x_tng, x, f_tng, f)
    implicit none
    real(8),dimension(:)::x_tng
    real(8),dimension(:)::x
    real(8)::f_tng
    real(8)::f
    integer::i
    f_tng = 0
    f = 0
    do i = 1, size(x)
       f_tng = f_tng + 2 * x(i) * x_tng(i)
       f = f + x(i)**2
    end do
    f_tng = f_tng / (2 * sqrt(f))
    f = sqrt(f)
  end subroutine eval_tng
end program main
