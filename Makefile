SHELL=/bin/bash 

PWD=$(shell pwd)
ROOT_BUILD=$(PWD)/build

TARGETS:=skalibs execline s6-portable-utils s6-linux-utils s6-dns s6

define build-pkg
	@echo -e "\e[0;33mStart building $(1), ...\e[0m"
	make build-$(1)
	@echo -e "\e[0;33mStop building $(1)\e[0m"
endef

all: $(TARGETS)

distclean:
	@-rm -rf $(ROOT_BUILD)
	
clean:
	$(foreach tgt,$(TARGETS), make clean-$(tgt))
	
prepare-%:
	@echo -e "\e[0;32mPrepare $(subst prepare-,,$@)\e[0m"
	@mkdir -pv $(ROOT_BUILD)/$(subst prepare-,,$@)

cmake-%: 
	make prepare-$(subst cmake-,,$@)
	@echo -e "\e[0;32mCmake $(subst cmake-,,$@)\e[0m"
ifeq ($(wildcard $(ROOT_BUILD)/$(subst cmake-,,$@)/Makefile),)
	@cd $(ROOT_BUILD)/$(subst cmake-,,$@) && cmake $(PWD)/$(subst cmake-,,$@)
endif    

build-%: 
	make cmake-$(subst build-,,$@)
	@echo -e "\e[0;32mBuild $(subst build-,,$@)\e[0m"
	@cd $(ROOT_BUILD)/$(subst build-,,$@) && make package
	@mv $(ROOT_BUILD)/$(subst build-,,$@)/$(subst build-,,$@)*{deb,tar.gz} $(ROOT_BUILD)
	
clean-%: 
	@echo -e "\e[0;32mClean $(subst clean-,,$@)\e[0m"
	@rm -fv $(ROOT_BUILD)/$(subst clean-,,$@)*{deb,tar.gz} 
	@cd $(ROOT_BUILD)/$(subst clean-,,$@) && make clean        

.PHONY: $(TARGETS)
$(TARGETS):
	$(call build-pkg,$@)


	
