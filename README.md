# Single Linked List

The module __Data\_Type\_SL\_List__ contains the definition of derived type, __Type\_SL\_List__, implementing a __generic__ Single-Linked List. The term __generic__ means that the data stored in each node (link) of the list is truly __generic__: at present, the stored data can be integer (of any kinds defined in IR\_Precision module), real (of any kinds defined in IR\_Precision module) and characters (of any length). The list links (nodes) can be either homogeneous or not.

The module is written in pure Fortran (standard 2003).

## Introduction

__Type\_SL\_List__ is a tentative to implement Python's list type in pure Fortran. The implementation is just started and many limitations are present, but the module is already useful.

The only public entities of __Data\_Type\_SL\_List__  are __SL\_List\_Mold__ (prototype for encoding/decoding data) and __Type\_SL\_List__ itself. In order to insert and retrieve data from the list nodes (and in general for list manipulation) the type bound methods of __Type\_SL\_List__ must be used, because the stored data are not directly accessible. This is due to the internal representation of the data. In order to allow generic data, the intrinsic __transfer__ function is used to encode all user data into the internal integer(I1P) array (pointer) representation. As a consequence, if the node is directed accessed the user can obtain unpredictable results due to the encoded (by means of __SL\_List\_Mold__) internal representation.

### Compiling

 __Type\_SL\_List__ must be compiled against __IR\_Precision__ module.

 The present project contains a program, __Test\_Diver.f90__ for testing the list type. It must be compiled against __Data\_Type\_OS.f90__, __Data\_Type\_SL\_List.f90__ and __Lib\_IO\_Misc.f90__ that are present into __src__ directory.

 In order to compile the program a modern Fortran compiler is necessary. Supported compiler is Intel Fortran Compiler (12.x or higher). For compile __Test\_Diver__ program use the provided makefile:

> make

### Usage

First of all, the module namespace must be imported and the list defined:

`USE Data_Type_SL_List
type(Type_SL_List):: list`

The list is now already instantiated and ready to be populated. At present, two attributes of the list are directly accessible:

1. `list%l` and integer containing the actual length of the list (equals to 0 when the list is firstly defined)
2. `list%homo` a logical indicating if the list has homogeneous (".true.") or not (".false.") nodes data.

Note that the list links (nodes) are indexed starting from 1, i.e. [1:list%l].

To populate the list simply use one of the three __put__ methods presently available:

1. Head inserting: ``list%puth(d='First data is a string')``;
2. tail inserting: ``list%putt(d='First data is a string')``;
3. direct-index-node inserting: ``list%put(n=1,d='First data is a string')``.

The three above insertions has identical result because it is the first insertion. It is important to note that the third method using direct-index-node reference can accept out-of-bounds index without rising an error. As an example the above third insertion could be replaced, with the same result, by any of the following insertions:

- ``list%put(n=0,d=First data is a string)``;
- ``list%put(n=-1,d=First data is a string)``;
- ``list%put(n=100,d=First data is a string)``;

The direct-index-node insertion method always checks if the used node-index is out-of-bounds [1:list%l] and, in case, the node 1 (if `n<1`) or list%l (if `n>list%l`) are used.

Assuming that the list have been created as following:

- ``list%putt(d=First data is a string)``;
- `list%putt(d=2_I4P)` ! the second is a integer(I4P);
- `list%putt(d=3._R4P)` ! the third is a single precision real, real(R4P);
- `list%putt(d=4_I8P)` ! the fourth is a long integer, integer(I8P);

The list is not homogeneous, i.e. `list%homo=.false.`, and has four nodes, i.e. `list%l=4`. In order to retrieve nodes data the `get#` methods must be used:

1. Head retrieving: `list%geth(d=d_ch)`;
2. tail retrieving: `list%gett(d=d_I8P)`;
3. direct-index-node retrieving: `list%get(n=3,d=d_R4P)`.

where the data variables have been defined as:

`character(100):: d_ch
integer(I8P)::    d_I8P
real(R4P)::       d_R4P`

For more details see the examples present in src/Test\_Driver.f90.

To run the program type:

> ./Test\_Driver
that will print:

     Test_Driver: a "driver" program for testing Type_SL_List functions
     Usage:
       Test_Driver [-switch]
         switch = integer   => testing integer list functions
         switch = real      => testing real list functions
         switch = character => testing character list functions
         switch = logical   => testing logical list functions
         switch = hetero    => testing hetero list functions
         switch = all       => testing all functions
     Examples:
       Test_Driver -integer
       Test_Driver -logical
     If switch is not passed this help message is printed to stdout

To see the list in action use one of the above switches and following the command line wizard.

## Todo

- Allow array data storage;
- complete documentation;

## Copyrights

The __Data\_Type\_SL\_List__ module is an open source project, it is distributed under the [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html). Anyone is interest to use, to develop or to contribute to __Data\_Type\_SL\_List__ is welcome.
