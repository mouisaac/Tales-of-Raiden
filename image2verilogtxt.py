#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import tkinter
import tkinter.filedialog
from PIL import Image, ImageDraw
import PIL.ImageOps

__DEFAULT_VAR_NAME__ = "var1"
__IS_MARK_CENTER__ = False
__INVERT_COLOR__ = False

def main():
	try:
		tkinter.Tk().withdraw() # Close the root window
		in_path = str(tkinter.filedialog.askopenfilename())
		print("Opening: {0}".format(in_path))
		outputpath = str(tkinter.filedialog.asksaveasfilename())
		im = Image.open(in_path)
		w, h = im.size
		outputpath = outputpath.format(width=w, w=w, height=h, h=h)
		with open(outputpath, 'w') as f:
			print("Output:  {0}".format(outputpath))
			variableName = input('Type variable name (enter to use "{0}" as variable name) :'.format(__DEFAULT_VAR_NAME__)).strip()
			if variableName == "":
				variableName = __DEFAULT_VAR_NAME__

			if __INVERT_COLOR__:
				r,g,b,a = im.split()
				rgb_image = Image.merge('RGB', (r,g,b))
				inverted_image = PIL.ImageOps.invert(rgb_image)
				r2,g2,b2 = inverted_image.split()
				im = Image.merge('RGBA', (r2,g2,b2,a))
			rgb_im = im.convert('RGBA')
			resultImage = Image.new('RGBA', (w, h))
			draw = ImageDraw.Draw(resultImage)

			# f.write("reg [{3}:0] {0}[{1}] = {2} ".format(variableName, h, '{', (w*2)-1 ))
			f.write("module {0}(\n".format(variableName))
			f.write("	input clk,\n")
			f.write("	input wire [9:0] characterPositionX,\n")
			f.write("	input wire [8:0] characterPositionY,\n")
			f.write("	input wire [9:0] drawingPositionX,\n")
			f.write("	input wire [8:0] drawingPositionY,\n")
			f.write("	output reg [2:0] plot\n")
			f.write(");\n")
			f.write("	reg [9:0] x;\n")
			f.write("	reg [9:0] y;\n")
			f.write("	initial begin\n")
			f.write("		x = 'd0;\n")
			f.write("		y = 'd0;\n")
			f.write("	end\n")
			f.write("\n")
			f.write("	always @(posedge clk) begin\n")
			f.write("		x <= (drawingPositionX - characterPositionX + {0});\n".format(int(w/2)+1))
			f.write("		y <= (drawingPositionY - characterPositionY + {0});\n".format(int(h/2)+1))
			if(__IS_MARK_CENTER__):
				f.write("		if(");
				f.write("x == {0:d} && y == {1:d} || ".format((w/2), (h/2)))
				f.write("x == {0:d} && y == {1:d} || ".format((w/2), (h/2)-1))
				f.write("x == {0:d} && y == {1:d} || ".format((w/2), (h/2)+1))
				f.write("x == {0:d} && y == {1:d} || ".format((w/2)-1, (h/2)))
				f.write("x == {0:d} && y == {1:d} || ".format((w/2)-1, (h/2)-1))
				f.write("x == {0:d} && y == {1:d} || ".format((w/2)-1, (h/2)+1))
				f.write("x == {0:d} && y == {1:d} || ".format((w/2)+1, (h/2)))
				f.write("x == {0:d} && y == {1:d} || ".format((w/2)+1, (h/2)-1))
				f.write("x == {0:d} && y == {1:d} )".format((w/2)+1, (h/2)+1))
				f.write("\tbegin\trgb <= 3'b010;\tend\n")

			i = 0
			for y in range(1,h):
				# f.write("{0}'b".format((w*2)))
				for x in range(1,w):
					r, g, b, alpha = rgb_im.getpixel((x, y))
					# grayScale = r * 299.0/1000 + g * 587.0/1000 + b * 114.0/1000
					# grayScale = int(grayScale/256*4)
					# grayScale = int(grayScale/256*8)
					grayScale = 0;
					if r > 125:
						grayScale += 4
					if g > 125:
						grayScale += 2
					if b > 125:
						grayScale += 1

					print("Pixel: ({0},{1}) = ({2},{3},{4}, {6}) => {5:03b}".format(x, y, r, g, b, grayScale, alpha))
					draw.point((x,y), (255 if r > 125 else 0, 255 if g > 125 else 0, 255 if b > 125 else 0, alpha))
					# f.write("{0}{1}".format('1' if grayScale >= 2 else '0', '1' if grayScale%2 == 1 else '0'))
					if(alpha > 128 and grayScale > 0) :
						f.write("\t\t")
						if(__IS_MARK_CENTER__ or i > 0): f.write("else ")
						# f.write("if(x=={0} && y=={1}) begin\tplot <= 1'b{2}{3}{4};	end\n".format(x, y, 1 if # r > 125 else 0, 1 if g > 125 else 0, 1 if b > 125 else 0))
						f.write("if(x=={0} && y=={1}) begin\tplot <= 1'b1;	end\n".format(x, y, 1 if r > 125 else 0, 1 if g > 125 else 0, 1 if b > 125 else 0))
						i += 1
			f.write("		else begin plot <= 1'b0; end// Width: {0}, Height: {1} From: {2}\n".format(w,h,in_path))
			f.write("	end\nendmodule\n")
			f.close()
			resultImage.save(outputpath+".png", 'PNG')
			os.system("start "+outputpath)
			os.system("start "+outputpath+".png")
	except Exception as e:
		print(e)
if __name__ == "__main__":
	main()


# im = Image.open('image.gif')
# rgb_im = im.convert('RGB')
