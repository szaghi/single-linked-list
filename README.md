Single Linked List
==================

The module Data\_Type\_SL\_List contains the definition of derived type implementing a __generic__ Single-Linked List. The term __generic__ means that the data stored in each node (link) of the list is truly __generic__: at present, the stored data can be integer (of any kinds defined in IR\_Precision module), real (of any kinds defined in IR\_Precision module) and characters (of any length). The list links (nodes) can be either homogeneous or not.

The module is written in pure Fortran (standard 2003).

Introduction
------------

In order to insert and retrieve data from the list nodes (and in general for list manipulation) the type bound methods must be used, because the data is not directly accessible. This is due to the internal representation of the data. In order to allow generic data, the intrinsic __transfer__ function is used to encode all user data into the internal integer(I1P) array (pointer) representation. As a consequence, if the node is directed accessed the user can obtain unpredictable results due to the encoded internal representation.

Copyrights
----------

The Data\_Type\_SL\_List module is an open source project, it is distributed under the [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html). Anyone is interest to use, to develop or to contribute to Data\_Type\_SL\_List is welcome.
