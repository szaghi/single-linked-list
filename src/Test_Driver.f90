!> @addtogroup Program Programs
!> List of excutable programs.

!> @ingroup Program
!> @{
!> @defgroup Test_DriverProgram Test_Driver
!> @}

!> "Driver" program for testing Type_SL_List functions.
!> @note
!> For printing help message for usage run it without command line arguments
!> @code
!> ./Test_Driver
!> @endcode
!> For testing (homogeneous) integer list run it as following:
!> @code
!> ./Test_Driver -integer
!> @endcode
!> For testing (homogeneous) real list run it as following:
!> @code
!> ./Test_Driver -real
!> @endcode
!> For testing (homogeneous) character list run it as following:
!> @code
!> ./Test_Driver -character
!> @endcode
!> For testing (homogeneous) logical list run it as following:
!> @code
!> ./Test_Driver -logical
!> @endcode
!> For testing non homogeneous (heterogeneous) list run it as following:
!> @code
!> ./Test_Driver -hetero
!> @endcode
!> For testing all kinds of list run it as following:
!> @code
!> ./Test_Driver -all
!> @endcode
!> @author    Stefano Zaghi
!> @version   1.0
!> @date      2013-03-28
!> @copyright GNU Public License version 3.
!> @todo \b Documentation: complete documentation.
!> @ingroup Test_DriverProgram
program Test_Driver
!-----------------------------------------------------------------------------------------------------------------------------------
USE IR_Precision
USE Data_Type_SL_List
USE Lib_IO_Misc
USE, intrinsic:: ISO_FORTRAN_ENV, only: stdout=>OUTPUT_UNIT, stderr=>ERROR_UNIT
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
integer(I4P)::  Nca = 0 !< Number of command line arguments.
character(10):: cas     !< Command line argument switch.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
Nca = command_argument_count()
if (Nca==0) then
  call print_usage
endif
call get_command_argument(1,cas)
select case(trim(cas))
case('-integer')
  call test_integer
case('-real')
  call test_real
case('-character')
  call test_character
case('-logical')
  call test_logical
case('-hetero')
  call test_hetero
case('-all')
  call test_integer
  call test_real
  call test_character
  call test_logical
  call test_hetero
case default
  write(stderr,'(A)')' Switch '//trim(cas)//' unknown'
  call print_usage
endselect
stop
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  !> Subroutine for printing usage help message to stdout.
  subroutine print_usage()
  !---------------------------------------------------------------------------------------------------------------------------------
  implicit none
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  write(stdout,'(A)')' Test_Driver: a "driver" program for testing Type_SL_List functions'
  write(stdout,'(A)')' Usage:'
  write(stdout,'(A)')'   Test_Driver [-switch]'
  write(stdout,'(A)')'     switch = integer   => testing integer list functions'
  write(stdout,'(A)')'     switch = real      => testing real list functions'
  write(stdout,'(A)')'     switch = character => testing character list functions'
  write(stdout,'(A)')'     switch = logical   => testing logical list functions'
  write(stdout,'(A)')'     switch = hetero    => testing hetero list functions'
  write(stdout,'(A)')'     switch = all       => testing all functions'
  write(stdout,'(A)')' Examples:'
  write(stdout,'(A)')'   Test_Driver -integer'
  write(stdout,'(A)')'   Test_Driver -logical'
  write(stdout,'(A)')' If switch is not passed this help message is printed to stdout'
  stop
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine print_usage

  !> Subroutine for testing integer list functions.
  subroutine test_integer()
  !---------------------------------------------------------------------------------------------------------------------------------
  implicit none
  type(Type_SL_List)::          list
  integer(I4P), allocatable::   array(:)
  integer(I4P)::                d
  character(500)::              sbuf
  character(500), allocatable:: toks(:)
  integer(I4P)::                Nl
  integer(I4P)::                l
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  test: do
    call list%free
    write(stdout,'(A)')' Testing integer list functions'
    write(stdout,'(A)')' Type the integer list (";" separated, e.g. 2;3;8;1;-16;2;189;4) or quit to end testing'
    read(stdout,*)sbuf ; sbuf = trim(adjustl(sbuf)) ; if (trim(sbuf)=='quit') exit test
    call tokenize(strin=sbuf,delimiter=';',Nt=Nl,toks=toks)
    do l=1,Nl
      call list%putt(d=cton(trim(toks(l)),1_I4P))
    enddo
    write(stdout,'(A)')' Converting list to array'
    if (list%homo) then
      call list%array(array)
    else
      write(stdout,'(A)')' You have typed a heterogeneous list thus it is not possible to convert list to array'
      cycle test
    endif
    write(stdout,'(A)')' You have typed the following list:'
    do l=1,list%l
      call list%get(n=l,d=d)
      write(stdout,'(A)')'   n: '//trim(strz(3,l))//' d (array value check): '//trim(str(n=d))//' ('//trim(str(n=array(l)))//')'
    enddo
  enddo test
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine test_integer

  !> Subroutine for testing real list functions.
  subroutine test_real()
  !---------------------------------------------------------------------------------------------------------------------------------
  implicit none
  type(Type_SL_List)::          list
  real(R8P), allocatable::      array(:)
  real(R8P)::                   d
  character(500)::              sbuf
  character(500), allocatable:: toks(:)
  integer(I4P)::                Nl
  integer(I4P)::                l
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  test: do
    call list%free
    write(stdout,'(A)')' Testing real list functions'
    write(stdout,'(A)')' Type the real list (";" separated, e.g. 2.;3.;8.;-11) or quit to end testing'
    read(stdout,*)sbuf ; sbuf = trim(adjustl(sbuf)) ; if (trim(sbuf)=='quit') exit test
    call tokenize(strin=sbuf,delimiter=';',Nt=Nl,toks=toks)
    do l=1,Nl
      call list%putt(d=cton(trim(toks(l)),1._R8P))
    enddo
    write(stdout,'(A)')' Converting list to array'
    if (list%homo) then
      call list%array(array)
    else
      write(stdout,'(A)')' You have typed a heterogeneous list thus it is not possible to convert list to array'
      cycle test
    endif
    write(stdout,'(A)')' You have typed the following list:'
    do l=1,list%l
      call list%get(n=l,d=d)
      write(stdout,'(A)')'   n: '//trim(strz(3,l))//' d (array value check): '//trim(str(n=d))//' ('//trim(str(n=array(l)))//')'
    enddo
  enddo test
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine test_real

  !> Subroutine for testing character list functions.
  subroutine test_character()
  !---------------------------------------------------------------------------------------------------------------------------------
  implicit none
  type(Type_SL_List)::          list
  character(10), allocatable::  array(:)
  character(10)::               d
  character(500)::              sbuf
  character(500), allocatable:: toks(:)
  integer(I4P)::                Nl
  integer(I4P)::                l
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  test: do
    call list%free
    write(stdout,'(A)')' Testing character list functions'
    write(stdout,'(A)')' Type the character list (";" separated, e.g. foo;fii;booooo;138loooooo) or quit to end testing'
    write(stdout,'(A)')' Note that each character node data must have up to 10 characters'
    read(stdout,*)sbuf ; sbuf = trim(adjustl(sbuf)) ; if (trim(sbuf)=='quit') exit test
    call tokenize(strin=sbuf,delimiter=';',Nt=Nl,toks=toks)
    do l=1,Nl
      call list%putt(d=toks(l)(1:10))
    enddo
    write(stdout,'(A)')' Converting list to array'
    if (list%homo) then
      call list%array(Nc=10,a=array)
    else
      write(stdout,'(A)')' You have typed a heterogeneous list thus it is not possible to convert list to array'
      cycle test
    endif
    write(stdout,'(A)')' You have typed the following list:'
    do l=1,list%l
      call list%get(n=l,d=d)
      write(stdout,'(A)')'   n: '//trim(strz(3,l))//' d (array value check): '//trim(d)//' ('//trim(array(l))//')'
    enddo
  enddo test
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine test_character

  !> Subroutine for testing logical list functions.
  subroutine test_logical()
  !---------------------------------------------------------------------------------------------------------------------------------
  implicit none
  type(Type_SL_List)::          list
  logical,       allocatable::  array(:)
  logical::                     d
  character(500)::              sbuf
  character(500), allocatable:: toks(:)
  integer(I4P)::                Nl
  integer(I4P)::                l
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  test: do
    call list%free
    write(stdout,'(A)')' Testing logical list functions'
    write(stdout,'(A)')' Type the logical list (";" separated, e.g. T;F;F;F;T;T;F) or quit to end testing'
    read(stdout,*)sbuf ; sbuf = trim(adjustl(sbuf)) ; if (trim(sbuf)=='quit') exit test
    call tokenize(strin=sbuf,delimiter=';',Nt=Nl,toks=toks)
    do l=1,Nl
      call list%putt(d=(trim(toks(l))=='T'))
    enddo
    write(stdout,'(A)')' Converting list to array'
    if (list%homo) then
      call list%array(array)
    else
      write(stdout,'(A)')' You have typed a heterogeneous list thus it is not possible to convert list to array'
      cycle test
    endif
    write(stdout,'(A)')' You have typed the following list:'
    do l=1,list%l
      call list%get(n=l,d=d)
      write(stdout,'(A,L1,A,L1,A)')'   n: '//trim(strz(3,l))//' d (array value check): ',d,' (',array(l),')'
    enddo
  enddo test
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine test_logical

  !> Subroutine for testing heterogeneous list functions.
  subroutine test_hetero()
  !---------------------------------------------------------------------------------------------------------------------------------
  implicit none
  type(Type_SL_List)::          list
  integer(I4P)::                d_i
  real(R8P)::                   d_r
  character(1)::                d_c
  logical::                     d_l
  character(500)::              sbuf
  character(500), allocatable:: toks1(:),toks2(:)
  character(3), allocatable::   tp(:)
  integer(I4P)::                Nl
  integer(I4P)::                l
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  test: do
    call list%free
    write(stdout,'(A)')' Testing heterogeneous list functions'
    write(stdout,'(A)')' Type the heterogeneous list (";" separated, e.g. LOG:T;INT:-11;REA:1021.;CHA:q) or quit to end testing'
    write(stdout,'(A)')' Where each node (must be 4) has two fields: field1:field2 '
    write(stdout,'(A)')'   field1 = INT => integer, REA => real, CHA => character, LOG => logical'
    write(stdout,'(A)')'   field2 = node value (e.g. -11 for integer data)'
    read(stdout,*)sbuf ; sbuf = trim(adjustl(sbuf)) ; if (trim(sbuf)=='quit') exit test
    call tokenize(strin=sbuf,delimiter=';',Nt=Nl,toks=toks1)
    if (allocated(tp)) deallocate(tp) ; allocate(tp(1:Nl))
    do l=1,Nl
      call tokenize(strin=toks1(l),delimiter=':',toks=toks2)
      tp(l) = trim(toks2(1))
      select case(tp(l))
      case('INT')
        call list%putt(d=cton(trim(toks2(2)),1_I4P))
      case('REA')
        call list%putt(d=cton(trim(toks2(2)),1._R8P))
      case('CHA')
        call list%putt(d=trim(toks2(2)))
      case('LOG')
        call list%putt(d=(trim(toks2(2))=='T'))
      endselect
    enddo
    write(stdout,'(A)')' You have typed the following list:'
    do l=1,list%l
      select case(tp(l))
      case('INT')
        call list%get(n=l,d=d_i)
        write(stdout,'(A)')'   n: '//trim(strz(3,l))//' d: '//trim(str(n=d_i))
      case('REA')
        call list%get(n=l,d=d_r)
        write(stdout,'(A)')'   n: '//trim(strz(3,l))//' d: '//trim(str(n=d_r))
      case('CHA')
        call list%get(n=l,d=d_c)
        write(stdout,'(A)')'   n: '//trim(strz(3,l))//' d: '//trim(d_c)
      case('LOG')
        call list%get(n=l,d=d_l)
        write(stdout,'(A,L1)')'   n: '//trim(strz(3,l))//' d: ',d_l
      endselect
    enddo
  enddo test
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine test_hetero
endprogram Test_Driver
