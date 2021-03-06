# Create a way to reformat just some files
ifdef PPFILES
  PP_INPUTS_FILTERED := $(wildcard $(PPFILES))
else
  PP_INPUTS = $(wildcard $(addprefix $(S)src/libcore/,*.rs */*.rs)) \
              $(wildcard $(addprefix $(S)src/libstd/,*.rs */*.rs)) \
              $(wildcard $(addprefix $(S)src/rustc/,*.rs */*.rs */*/*.rs)) \
              $(wildcard $(S)src/test/*/*.rs    \
                         $(S)src/test/*/*/*.rs) \
              $(wildcard $(S)src/fuzzer/*.rs)   \
              $(wildcard $(S)src/cargo/*.rs)

  PP_INPUTS_FILTERED = $(shell echo $(PP_INPUTS) | xargs grep -L \
                       "no-reformat\|xfail-pretty\|xfail-test")
endif

reformat: $(SREQ1$(CFG_HOST_TRIPLE))
	@$(call E, reformat [stage1]: $@)
	for i in $(PP_INPUTS_FILTERED);  \
    do $(call CFG_RUN_TARG,1,$(CFG_HOST_TRIPLE)/stage1/rustc$(X)) \
       --pretty normal $$i >$$i.tmp; \
    if [ $$? -ne 0 ]; \
        then echo failed to print $$i; rm $$i.tmp; \
        else if cmp --silent $$i.tmp $$i; \
            then echo no changes to $$i; rm $$i.tmp; \
            else echo reformated $$i; mv $$i.tmp $$i; \
        fi; \
    fi; \
    done
