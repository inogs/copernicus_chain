SHELL		= /bin/ksh
include CONFIG/Make.config

SCRIPTS=	opa_archive.ksh					\
		opa_check_input_files.ksh			\
		opa_get.ksh					\
		opa_get_emerg.ksh				\
                opa_get_recovery.ksh				\
		opa_input_files.inc				\
		opa_link_analyses.ksh				\
		opa_link_forecast.ksh				\
		opa_input_stagein.ksh				\
		opa_model.ksh					\
		opa_model__phase_B1.ksh				\
		opa_model__phase_B2.ksh				\
		opa_model_wrapper.ksh				\
		opa_mon.ksh					\
		opa_mpi.inc					\
		opa_mpi__mpich.inc				\
		opa_mpi__poe.inc				\
		opa_mpi__openmpi.inc				\
		opa_mpi__intelmpi.inc				\
		opa_post_wrapper.ksh				\
		opa_postproc.ksh				\
		opa_postproc__phase_C1.ksh			\
		opa_postproc__phase_C2.ksh			\
		opa_postproc__phase_C3.ksh			\
		opa_postproc__phase_C4.ksh			\
		opa_postproc__phase_C6.ksh			\
		opa_pre_wrapper.ksh				\
		opa_preproc.ksh					\
		opa_preproc__phase_A1.ksh			\
		opa_preproc__phase_A2.ksh			\
		opa_preproc__phase_A3.ksh			\
		opa_preproc__phase_A4.ksh			\
		opa_profile.inc					\
		opa_profile__galileo.inc			\
		opa_profile__meucci.inc				\
		opa_rm.inc					\
		opa_rm__pbs.inc					\
                opa_rm__slurm.inc				\
		opa_job.ksh					\
		opa_run_setup.ksh				\
		opa_setup_crontab.ksh				\
		opa_setup_grads.ksh				\
		opa_setup_environment.ksh			\
		opa_setup_directories.ksh			\
		opa_log_job.ksh					\
		opa_start.ksh					\
		opa_submit.ksh					\
		opa_log_inspect.py				\
		opa_postcheckout.ksh				\
		opa_put_phase_2.ksh				\
                opa_put_phase_2_monthly.ksh                     \
		opa_report.ksh					\
		opa_parse_reports.ksh				\
		opa_parse_reports.py				\
		opa_check_run.ksh				\
		opa_recovery.ksh				\
		opa_test_rundate_options.ksh			\
		opa_restart_cp.ksh				\
		opa_clean.ksh					\
		opa_lists.inc					\
		opa_test_lists.ksh				\
		opa_is_login_node.ksh				\
		opa_downloader.ksh				\
		opa_check_remote_cron.ksh			\
		opa_log_report.py				\


default:	compile

include CONFIG/Make.check

compile:	check $(SCRIPTS)

install:	check $(SCRIPTS)
		-@echo "Installing files:"
		@for script in $(SCRIPTS) ; do										\
			type=$$( echo $$script | awk 'BEGIN{FS="."}{if(NF > 1){print($$NF)}else{print ""}}');		\
			if [[ $$type = 'ksh' || $$type = 'bash' || $$type = 'py' || $$type = 'pl' || $$type = ''  ]] ; then		\
				dirs="$(INST_KSHDIR)";									\
				m="$(INST_KSHMOD)";									\
			elif [[ $$type = 'inc' ]] ; then								\
				dirs="$(INST_INCDIR)";									\
				m="$(INST_INCMOD)";									\
			else												\
				echo "ERROR: type <$$type>";								\
				return 1;										\
			fi;												\
			for d in $$dirs ; do										\
				if [[ ! -d $$d ]] ; then								\
					mkdir -p $$d;									\
				fi;											\
				if cmp $$script $$d/$$script 1>/dev/null 2>&1; then					\
					echo "script: <$$script>, type: <$$type> - SKIPPED";				\
					echo "origin: <./$$script>, target: <$$d/$$script>";				\
				else											\
					echo "script: <$$script>, type: <$$type>";					\
					if [ -f $d/$$script ] ; then							\
						chmod u+w $$d/$$script;							\
					fi;										\
					echo "	 *** cp -f $$script $$d";						\
					cp -f $$script $$d;								\
					echo "chmod $$m $$d/$$script";							\
					chmod $$m $$d/$$script;								\
				fi;											\
			done;												\
		done;

clean:		check
		rm -f $(SCRIPTS)




.SUFFIXES: .src_ksh .ksh .src_inc .inc .src_py .py .src_pl .pl

.src_py.py:		$(COMPILER)
			-@[[ -f $@ ]] && chmod u+w $@ 2>/dev/null || return 0
			$(COMPILER) $< $@
			chmod $(COMP_PYMOD) $@
			chmod $(SRC_PYMOD) $<

.src_pl.pl:		$(COMPILER)
			-@[[ -f $@ ]] && chmod u+w $@ 2>/dev/null || return 0
			$(COMPILER) $< $@
			chmod $(COMP_PLMOD) $@
			chmod $(SRC_PLMOD) $<

.src_ksh.ksh:		$(COMPILER)
			-@[[ -f $@ ]] && chmod u+w $@ 2>/dev/null || return 0
			$(COMPILER) $< $@
			chmod $(COMP_KSHMOD) $@
			chmod $(SRC_KSHMOD) $<

.src_inc.inc:		$(COMPILER)
			-@[[ -f $@ ]] && chmod u+w $@ 2>/dev/null || return 0
			$(COMPILER) $< $@
			chmod $(COMP_INCMOD) $@
			chmod $(SRC_INCMOD) $<

odd:			odd.src_py
			-@[[ -f $@ ]] && chmod u+w $@ 2>/dev/null || return 0
			$(COMPILER) odd.src_py $@
			chmod $(COMP_PYMOD) $@
			chmod $(SRC_PYMOD) odd.src_py

odd_verify:		odd_verify.src_py
			-@[[ -f $@ ]] && chmod u+w $@ 2>/dev/null || return 0
			$(COMPILER) odd_verify.src_py $@
			chmod $(COMP_PYMOD) $@
			chmod $(SRC_PYMOD) odd_verify.src_py

odd_compare:		odd_compare.src_py
			-@[[ -f $@ ]] && chmod u+w $@ 2>/dev/null || return 0
			$(COMPILER) odd_compare.src_py $@
			chmod $(COMP_PYMOD) $@
			chmod $(SRC_PYMOD) odd_compare.src_py

odd_guess_alpha:	odd_guess_alpha.src_py
			-@[[ -f $@ ]] && chmod u+w $@ 2>/dev/null || return 0
			$(COMPILER) odd_guess_alpha.src_py $@
			chmod $(COMP_PYMOD) $@
			chmod $(SRC_PYMOD) odd_guess_alpha.src_py

