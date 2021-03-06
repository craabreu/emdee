!   This file is part of EmDee.
!
!    EmDee is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    EmDee is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with EmDee. If not, see <http://www.gnu.org/licenses/>.
!
!    Author: Charlles R. A. Abreu (abreu@eq.ufrj.br)
!            Applied Thermodynamics and Molecular Simulation
!            Federal University of Rio de Janeiro, Brazil

module bond_harmonic_module

use global
use bondModelClass

implicit none

!> Abstract class for angle model harmonic
!!
!! NOTES: 1) model parameters must be declared individually and tagged with a comment mark "!<>"
!!        2) recognizable parameter types are real(rb) and integer(ib)
!!        3) allocatable one-dimensional arrays (i.e. vectors) are permitted as parameters
!!        4) an integer(ib) scalar parameter - a size - must necessarily succeed every allocatable
!!           parameter or series of equally-sized allocatable parameters.

type, extends(cBondModel) :: bond_harmonic
  real(rb) :: k   !<> Force constant
  real(rb) :: r0  !<> Equilibrium distance

  real(rb) :: minus_k, half_k
  contains
    procedure :: setup => bond_harmonic_setup
    procedure :: compute => bond_harmonic_compute
end type bond_harmonic

contains

!---------------------------------------------------------------------------------------------------

  subroutine bond_harmonic_setup( model, params, iparams )
    class(bond_harmonic), intent(inout) :: model
    real(rb), intent(in), optional :: params(:)
    integer,  intent(in), optional :: iparams(:)

    ! Model name:
    model%name = "harmonic"

    ! Model parameters:
    model%k = params(1)
    model%r0 = params(2)

    ! Pre-computed quantities:
    model%minus_k = -model%k
    model%half_k = half*model%k

  end subroutine bond_harmonic_setup

!---------------------------------------------------------------------------------------------------

  subroutine bond_harmonic_compute( model, E, W, invR2 )
    class(bond_harmonic), intent(in)  :: model
    real(rb),             intent(out) :: E, W
    real(rb),             intent(in)  :: invR2

    real(rb) :: delta, r

    r = one/sqrt(invR2)
    delta = r - model%r0
    E = model%half_k*delta**2
    W = model%minus_k*delta*r

  end subroutine bond_harmonic_compute

!---------------------------------------------------------------------------------------------------

end module bond_harmonic_module
