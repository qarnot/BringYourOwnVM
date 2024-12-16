all:
	pyinstaller -F --collect-all pyfiglet --onefile --windowed main.py
	mv dist/* .
	rm -rf ./build dist *.spec

clean:
	$(RM) ./main
