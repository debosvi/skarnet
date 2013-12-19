SHELL=/bin/bash 

PWD=$(shell pwd)
ROOT_BUILD=$(PWD)/build

TARGETS:=skalibs execline

all:
	$(foreach tgt, $(TARGETS), make build-$(tgt))

###########################################################################################
########################### SKALIBS #######################################################
###########################################################################################
prepare-skalibs:
	@echo -e "\e[0;32mPrepare $(subst prepare-,,$@)\e[0m"
ifeq ($(wildcard $(ROOT_BUILD)/$(subst prepare-,,$@)),)
	@mkdir -pv $(ROOT_BUILD)/$(subst prepare-,,$@)
endif	
	
cmake-skalibs: prepare-skalibs
	@echo -e "\e[0;32mCmake $(subst cmake-,,$@)\e[0m"
ifeq ($(wildcard $(ROOT_BUILD)/$(subst cmake-,,$@)/Makefile),)
	@cd $(ROOT_BUILD)/$(subst cmake-,,$@) && cmake $(PWD)/$(subst cmake-,,$@)
endif	

build-skalibs: cmake-skalibs
	@echo -e "\e[0;32mBuild $(subst build-,,$@)\e[0m"
	@cd $(ROOT_BUILD)/$(subst build-,,$@) && make package
	@mv $(ROOT_BUILD)/$(subst build-,,$@)/$(subst build-,,$@)*{deb,tar.gz} $(ROOT_BUILD)

clean-skalibs: 
	@echo -e "\e[0;32mClean $(subst clean-,,$@)\e[0m"
	@rm -fv $(ROOT_BUILD)/$(subst clean-,,$@)*{deb,tar.gz} 
	@cd $(ROOT_BUILD)/$(subst clean-,,$@) && make clean	

###########################################################################################
########################### EXECLINE ######################################################
###########################################################################################
prepare-execline:
	@echo -e "\e[0;32mPrepare $(subst prepare-,,$@)\e[0m"
ifeq ($(wildcard $(ROOT_BUILD)/$(subst prepare-,,$@)),)
	@mkdir -pv $(ROOT_BUILD)/$(subst prepare-,,$@)
endif	
	
cmake-execline: prepare-execline
	@echo -e "\e[0;32mCmake $(subst cmake-,,$@)\e[0m"
ifeq ($(wildcard $(ROOT_BUILD)/$(subst cmake-,,$@)/Makefile),)
	@cd $(ROOT_BUILD)/$(subst cmake-,,$@) && cmake $(PWD)/$(subst cmake-,,$@)
endif	

build-execline: cmake-execline
	@echo -e "\e[0;32mBuild $(subst build-,,$@)\e[0m"
	@cd $(ROOT_BUILD)/$(subst build-,,$@) && make package
	@mv $(ROOT_BUILD)/$(subst build-,,$@)/$(subst build-,,$@)*{deb,tar.gz} $(ROOT_BUILD)

clean-execline: 
	@echo -e "\e[0;32mClean $(subst clean-,,$@)\e[0m"
	@rm -fv $(ROOT_BUILD)/$(subst clean-,,$@)*{deb,tar.gz} 
	@cd $(ROOT_BUILD)/$(subst clean-,,$@) && make clean	

distclean:
	@-rm -rf $(ROOT_BUILD)