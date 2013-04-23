#!/usr/bin/make
#-----------------------------------------------------------------------------------------------------------------------------------
# options
FC    = ifort
DSRC  = src/
DOBJ  = ./obj/
DMOD  = ./mod/
DEXE  = ./
OPTSC = -cpp -c -std03 -warn all -check all -module $(DMOD)
OPTSL =
LIBS  =

.PHONY : DEFAULTRULE
DEFAULTRULE: $(DEXE)Test_Driver
#-----------------------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------------------
# auxiliary variables
VPATH = $(DSRC) $(DOBJ) $(DMOD) $(DLIB)
MKDIRS = $(DOBJ) $(DMOD) $(DEXE)
WHICHFC = $(shell which $(FC))
PRINTCHK = "\\033[1;31m Compiler used   \\033[0m\\033[1m $(FC) => $(WHICHFC)\\033[0m \n\
            \\033[1;31mSources dir     \\033[0m\\033[1m $(DSRC)\\033[0m \n\
            \\033[1;31mObjects dir     \\033[0m\\033[1m $(DOBJ)\\033[0m \n\
            \\033[1;31mModules dir     \\033[0m\\033[1m $(DMOD)\\033[0m \n\
            \\033[1;31mExecutables dir \\033[0m\\033[1m $(DEXE)\\033[0m \n\
            \\033[1;31mLibraries       \\033[0m\\033[1m $(LIBS)\\033[0m"
#-----------------------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------------------
# auxiliary rules
.PHONY : PRINTINFO
.NOTPARALLEL : PRINTINFO
PRINTINFO:
	@echo | tee make.log
	@echo -e $(PRINTCHK) | tee -a make.log
	@echo | tee -a make.log
	@echo -e "\033[1;31m Compiling options\033[0m" | tee -a make.log
	@echo -e "\033[1m [$(OPTSC)]\033[0m" | tee -a make.log
	@echo | tee -a make.log
	@echo -e "\033[1;31m Linking options \033[0m" | tee -a make.log
	@echo -e "\033[1m [$(OPTSL)]\033[0m" | tee -a make.log
	@echo | tee -a make.log

.PHONY : $(MKDIRS)
$(MKDIRS):
	@mkdir -p $@

.PHONY : cleanobj
cleanobj:
	@echo -e "\033[1;31m deleting objects \033[0m" | tee make.log
	@rm -fr $(DOBJ)

.PHONY : cleanmod
cleanmod:
	@echo -e "\033[1;31m deleting mods \033[0m" | tee -a make.log
	@rm -fr $(DMOD)

.PHONY : cleanexe
cleanexe:
	@echo -e "\033[1;31m deleting exes \033[0m" | tee -a make.log
	@rm -f $(addprefix $(DEXE),$(EXES))

.PHONY : cleanmsg
cleanmsg:
	@rm -f diagnostic_messages
	@rm -f error_messages

.PHONY : clean
clean: cleanobj cleanmod cleanmsg

.PHONY : cleanall
cleanall: clean cleanexe
#-----------------------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------------------
# rules of linking and compiling
COTEXT  = -e "\033[1;31m Compiling\033[0m\033[1m $(<F)\033[0m"
LITEXT  = -e "\033[1;31m Assembling\033[0m\033[1m $@\033[0m"
LCEXES  = $(shell echo $(EXES) | tr '[:upper:]' '[:lower:]')
EXESPO  = $(addsuffix .o,$(LCEXES))
EXESOBJ = $(addprefix $(DOBJ),$(EXESPO))

$(DEXE)Test_Driver : PRINTINFO $(MKDIRS) $(DOBJ)test_driver.o
	@rm -f $(filter-out $(DOBJ)test_driver.o,$(EXESOBJ))
	@echo | tee -a make.log
	@echo $(LITEXT) | tee -a make.log
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@ 1>> diagnostic_messages 2>> error_messages
EXES := $(EXES) Test_Driver

$(DOBJ)data_type_os.o : Data_Type_OS.f90 \
	$(DOBJ)ir_precision.o
	@echo $(COTEXT) | tee -a make.log
	@$(FC) $(OPTSC) $< -o $@ 1>> diagnostic_messages 2>> error_messages

$(DOBJ)data_type_sl_list.o : Data_Type_SL_List.f90 \
	$(DOBJ)ir_precision.o
	@echo $(COTEXT) | tee -a make.log
	@$(FC) $(OPTSC) $< -o $@ 1>> diagnostic_messages 2>> error_messages

$(DOBJ)ir_precision.o : IR_Precision.f90
	@echo $(COTEXT) | tee -a make.log
	@$(FC) $(OPTSC) $< -o $@ 1>> diagnostic_messages 2>> error_messages

$(DOBJ)lib_io_misc.o : Lib_IO_Misc.f90 \
	$(DOBJ)ir_precision.o \
	$(DOBJ)data_type_os.o
	@echo $(COTEXT) | tee -a make.log
	@$(FC) $(OPTSC) $< -o $@ 1>> diagnostic_messages 2>> error_messages

$(DOBJ)test_driver.o : Test_Driver.f90 \
	$(DOBJ)ir_precision.o \
	$(DOBJ)data_type_sl_list.o \
	$(DOBJ)lib_io_misc.o
	@echo $(COTEXT) | tee -a make.log
	@$(FC) $(OPTSC) $< -o $@ 1>> diagnostic_messages 2>> error_messages

$(DOBJ)%.o : %.f90
	@echo $(COTEXT) | tee -a make.log
	@$(FC) $(OPTSC) $< -o $@ 1>> diagnostic_messages 2>> error_messages

#-----------------------------------------------------------------------------------------------------------------------------------
