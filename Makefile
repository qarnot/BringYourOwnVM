all:
	pyinstaller -F --collect-all pyfiglet --onefile --windowed cli.py
	mv dist/* .
	rm -rf ./build dist *.spec

clean:
	$(RM) ./cli
