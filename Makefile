all: AE/Documentation/AE.pdf

AE/Documentation/AE.pdf:
	make -C $(dir $@) $(notdir $@)

clean:
	make -C AE/Documentation clean
	make -C AE/Schematic clean
