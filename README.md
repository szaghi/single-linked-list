# Single Linked List

The module __Data\_Type\_SL\_List__ contains the definition of derived type, __Type\_SL\_List__, implementing a __generic__ Single-Linked List. The term __generic__ means that the data stored in each node (link) of the list is truly __generic__: at present, the stored data can be integer (of any kinds defined in IR\_Precision module), real (of any kinds defined in IR\_Precision module) and characters (of any length). The list links (nodes) can be either homogeneous or not.

The module is written in pure Fortran (standard 2003).

## Introduction

__Type\_SL\_List__ is a tentative to implement Python's list type in pure Fortran. The implementation is just started and many limitations are present, but the module is already useful.

The only public entities of __Data\_Type\_SL\_List__  are __SL\_List\_Mold__ (prototype for encoding/decoding data) and __Type\_SL\_List__ itself. In order to insert and retrieve data from the list nodes (and in general for list manipulation) the type bound methods of __Type\_SL\_List__ must be used, because the stored data are not directly accessible. This is due to the internal representation of the data. In order to allow generic data, the intrinsic __transfer__ function is used to encode all user data into the internal integer(I1P) array (pointer) representation. As a consequence, if the node is directed accessed the user can obtain unpredictable results due to the encoded (by means of __SL\_List\_Mold__) internal representation.

### Usage

Importing module namespace and defining the list:

`
USE Data_Type_SL_List
type(Type_SL_List):: list
`

The list is now already instantiated and ready to be populated. At present, two attributes of the list are directly accessible:

1. `list%l` and integer containing the actual length of the list (equals to 0 when the list is firstly defined)
2. `list%homo` a logical indicating if the list has homogeneous (".true.") or not (".false.") nodes data.

To populate the list simply use one of the three __put__ methods presently available:

1. Head inserting: `list%puth(d='First data is a string')`;
2. Tail inserting: `list%putt(d='First data is a string')`;
3. Direct index node inserting: `list%put(n=1,d='First data is a string')`;

## Todo

- Allow array data storage;
- complete documentation;
- write test\_driver program.


## Copyrights

The __Data\_Type\_SL\_List__ module is an open source project, it is distributed under the [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html). Anyone is interest to use, to develop or to contribute to __Data\_Type\_SL\_List__ is welcome.
