from tkinter import *
from PIL import ImageTk, Image
from PIL import ImageFilter
from PIL import sys

from tkinter import filedialog
import math#  --onefile BMPConverter.py
# a tool to convert an image to SYSTEM VERILOG bitmap for Lab1 projects
# writen by Noam and DAvid Bar-On  for the elementary lab in the Technion IIT 2021
# (c) Technion IIT 2021

global imgFromFile   # original image as read from file
global imgOriginal   # original size image
global imgBMP # converted and pixelized image
global FileName  # bare file name- without paty and extensions"
global root

# scales parameters
global bmpScale
global Rlambda, Glambda, Blambda  # color correcting coefficients
global grayThreshold

# button parameters
global SingleBitBitMap #  select: one or eight bits
global OneBitbutton
SingleBitBitMap = FALSE  # start with 8 bits

global InvertGrayScale
global InvertGrayScalebutton
InvertGrayScale = TRUE


global TL_BMP_Position
TL_BMP_Position = (400,50)
Original_Position = (100,50)

## how to make an exe program
# https://datatofish.com/executable-pyinstaller/
#   CD PYTHON
#   pyinstaller --onefile BMPConverter.py
# take the exe from dist directory

# ______________________________________________________display controls

def selectmouse(v):
    global imgOriginal, imgBMP
    xx = v.x
    yy = v.y  #  get the mousק position in the picture
# get the position in the ROOT array to see the click is only in the BMP window
    abs_coord_x = root.winfo_pointerx() - root.winfo_rootx()
    abs_coord_y = root.winfo_pointery() - root.winfo_rooty()
    mouse = ( root.winfo_pointerx() -  root.winfo_rootx() ,   root.winfo_pointery() -  root.winfo_rooty() )
    cordinate = xx, yy

# if mouse is in BMP screen
    if ( TL_BMP_Position[0] < abs_coord_x ) and ((TL_BMP_Position[0] + imgOriginal.size[0]) > abs_coord_x) and (TL_BMP_Position[1] < abs_coord_y) and ((TL_BMP_Position[1] + imgOriginal.size[1] ) > abs_coord_y):
        print("in Right")

        img256 = imgBMP.resize(imgOriginal.size,Image.NEAREST)
        r, g, b = img256.getpixel(cordinate)
        # change pixels on the small imgBMP array
        pixels = imgBMP.load()  # create the pixel map

        for i in range(imgBMP.size[0]):  # for each column
            for j in range(imgBMP.size[1]):  # For each row
                if pixels[i, j][0] == r and pixels[i, j][1] == g and pixels[i, j][2] == b:
                    pixels[i, j] = (0, 0, 0)

        # if mouse is in original screen

    if (Original_Position[0] < abs_coord_x) and ((Original_Position[0] + imgOriginal.size[0]) > abs_coord_x) and ( Original_Position[1] < abs_coord_y) and ((Original_Position[1] + imgOriginal.size[1]) > abs_coord_y):
        print ("in left", cordinate)
        r, g, b = imgOriginal.getpixel(cordinate)
        print (r, g, b)

         # change pixels on the large array
        Opixels = imgOriginal.load()  # create the pixel map
        threshold = 20
        for i in range(imgOriginal.size[0]):  # for each column
            for j in range(imgOriginal.size[1]):  # For each row
                if (math.fabs(Opixels[i, j][0] - r) < threshold ) and (math.fabs(Opixels[i, j][1] - g) < threshold ) and (math.fabs(Opixels[i, j][2] - b) < threshold ):
            #if (math.fabs()Opixels[i, j][0] == r) and (Opixels[i, j][1] == g) and (Opixels[i, j][2] == b):

                    # print("match Left", i,j,Opixels[i, j])
                    Opixels[i, j] = (0,0,0)
        picModify(0)  #  if click on left side
    OriginalpicDisplay()

    BMPpicDisplay()


def OpenGUIKeys():
    global bmpScale, ResizeScale
    global Rlambda, Glambda, Blambda  # color correcting coefficients
    global OneBitbutton
    global grayThreshold
    global InvertGrayScalebutton

    # sliders
    bmpScale = Scale(root, from_=0, to=6, label="2^scale", variable=IntVar(), command=picModify)
    bmpScale.set(3)
    bmpScale.place(x=0, y=100)

    ResizeScale = Scale(root, from_=0, to=5, label="Mode", variable=IntVar(), command=picModify)
    ResizeScale.set(0)
    ResizeScale.place(x=0, y=250)

    # gray scale controls
    grayThreshold = Scale(root, from_=0, to=256, label="off", variable=IntVar(), command=picModify)
    grayThreshold.set(256)
    grayThreshold.place(x=550, y=350)

    InvertGrayScalebutton = Button(root, text="            ", command=InvertSelect)
    InvertGrayScalebutton.place(x=550, y=500)

    # color
    Rlambda = Scale(root, from_=0, to=200, label="            R", orient=HORIZONTAL, variable=IntVar(), command=picModify)
    Rlambda.set(100)
    Rlambda.place(x=400, y=310)

    Glambda = Scale(root, from_=0, to=200, label="            G", orient=HORIZONTAL, variable=IntVar(), command=picModify)
    Glambda.set(100)
    Glambda.place(x=400, y=370)

    Blambda = Scale(root, from_=0, to=200, label="            B", orient=HORIZONTAL, variable=IntVar(), command=picModify)
    Blambda.set(100)
    Blambda.place(x=400, y=430)

    #buttons



    Initbutton = Button(root, text="reset To original", command=ResetToOriginal)
    Initbutton.place(x=50, y=320)





    # filters
    BLUR_Button= Button(root, text="BLUR", command=BLURKey)
    BLUR_Button.place(x=100, y=345)

    CONTOUR_Button= Button(root, text="CONTOUR", command=CONTOURKey)
    CONTOUR_Button.place(x=100, y=370)

    DETAIL_Button= Button(root, text="DETAIL", command=DETAILKey)
    DETAIL_Button.place(x=100, y=395)

    EDGE_ENHANCE_Button= Button(root, text="EDGE_ENHANCE", command=EDGE_ENHANCEKey)
    EDGE_ENHANCE_Button.place(x=100, y=420)

    EDGE_ENHANCE_MORE_Button= Button(root, text="EDGE_ENHANCE_1", command=EDGE_ENHANCE_MOREKey)
    EDGE_ENHANCE_MORE_Button.place(x=100, y=445)

    EMBOSS_Button= Button(root, text="EMBOSS", command=EMBOSSKey)
    EMBOSS_Button.place(x=250, y=345)

    FIND_EDGES_Button= Button(root, text="FIND_EDGES", command=FIND_EDGESKey)
    FIND_EDGES_Button.place(x=250, y=370)

    SMOOTH_Button= Button(root, text="SMOOTH", command=SMOOTHKey)
    SMOOTH_Button.place(x=250, y=395)

    SMOOTH_MORE_Button= Button(root, text="SMOOTH_1", command=SMOOTH_MOREKey)
    SMOOTH_MORE_Button.place(x=250, y=420)

    SHARPEN_Button = Button(root, text="SHARPEN", command=SharpenKey)
    SHARPEN_Button.place(x=250, y=445)

    OneBitbutton = Button(root, text="8 bit (press for 1 bit)", bg='green', command=SingleBitBitMapSelect)
    OneBitbutton.place(x=50, y=500)

    SVFilebutton = Button(root, text="create SV file & exit", bg='light blue', command=writeVerilog)
    SVFilebutton.place(x=300, y=500)

# ____________________________________________________________________________________________________
def InvertSelect():
    # change the flag for inverting single bit BITMAP
    global InvertGrayScale
    global InvertGrayScalebutton

    if SingleBitBitMap :  #  only valid in single bit mode
        InvertGrayScale = not InvertGrayScale
        if InvertGrayScale :
            InvertGrayScalebutton.config(text="invert(off)")
        else :
            InvertGrayScalebutton.config(text="invert(on)")
        picModify(0)


# ____________________________________________________________________________________________________
def SingleBitBitMapSelect():
    # selcet the mode:  8 bit or 1 bit
    global SingleBitBitMap
    global OneBitbutton
    global grayThreshold
    global  InvertGrayScalebutton

    SingleBitBitMap = not SingleBitBitMap

    if SingleBitBitMap :
        OneBitbutton.config(text="1 bit (press for 8 bit)",bg='gray')
        grayThreshold.config(label="gray Threshold")
        InvertGrayScalebutton.config (text="invert(off)")
    else :
        OneBitbutton.config(text="8 bit (press for 1 bit)",bg='green')
        grayThreshold.config(label="off")
        InvertGrayScalebutton.config(text="            ")
    picModify(0)


# ____________________________________________________________________________________________________

def BMPpicDisplay():
    # print ("BMPicDisplay")
    #  extend the BMP to the original size and display it
    img256 = imgBMP.resize(imgOriginal.size,Image.NEAREST)
    img256 = ImageTk.PhotoImage(img256)
    RightImage = Label(root, image=img256)
    RightImage.place (x=TL_BMP_Position[0],y= TL_BMP_Position[1]) # (x=400, y=50)
    RightImage.image = img256

def OriginalpicDisplay():
    #global imgOriginal
   # img255 = imgOriginal.resize(imgOriginal.size,Image.NEAREST)
    IMG255 = ImageTk.PhotoImage(imgOriginal)
    LeftImage = Label(root, image=IMG255)
    LeftImage.place(x=Original_Position[0],y= Original_Position[1])
    LeftImage.image = IMG255


# ____________________________________________________________________________________________________
def writeVerilog():
    verilogText1 ="// bitmap file \n// (c) Technion IIT, Department of Electrical Engineering 2021 \n// generated bythe automatic Python tool \n \n \n"
    verilogText2 ="\n					input	logic	clk, \n					input	logic	resetN, \n					input logic	[10:0] offsetX,// offset from top left  position \n					input logic	[10:0] offsetY, \n					input	logic	InsideRectangle, //input that the pixel is within a bracket \n \n					output	logic	drawingRequest, //output that the pixel should be dispalyed \n					output	logic	[7:0] RGBout,  //rgb value from the bitmap \n					output	logic	[3:0] HitEdgeCode //one bit per edge \n ) ; \n \n \n// generating the bitmap \n"
    verilogText3 ='\nlocalparam logic [7:0] TRANSPARENT_ENCODING = 8\'h00 ;// RGB value in the bitmap representing a transparent pixel '
    verilogText3A = '\nlocalparam logic [7:0] COLOR_ENCODING = 8\'hFF ;// RGB value in the bitmap representing the BITMAP coolor'
    verilogText4 ="\n \n \n//////////--------------------------------------------------------------------------------------------------------------= \n//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	 \n//there is one bit per edge, in the corner two bits are set  \n logic [0:3] [0:3] [3:0] hit_colors = \n		   {16'hC446,     \n			16'h8C62,    \n			16'h8932, \n			16'h9113}; \n // pipeline (ff) to get the pixel color from the array 	 \n//////////--------------------------------------------------------------------------------------------------------------= \nalways_ff@(posedge clk or negedge resetN) \nbegin \n	if(!resetN) begin \n		RGBout <=	8'h00; \n		HitEdgeCode <= 4'h0; \n	end \n	else begin \n		RGBout <= TRANSPARENT_ENCODING ; // default  \n		HitEdgeCode <= 4'h0; \n \n		if (InsideRectangle == 1'b1 ) \n		begin // inside an external bracket "
    verilogText5 ="\n			RGBout <= (object_colors[offsetY][offsetX] ==  1 ) ? COLOR_ENCODING  : TRANSPARENT_ENCODING; \n		end  	 \n		 \n	end \nend \n \n//////////--------------------------------------------------------------------------------------------------------------= \n// decide if to draw the pixel or not \nassign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   \n \nendmodule"
    verilogText5A = "\n			RGBout <= object_colors[offsetY][offsetX]; \n		end  	 \n		 \n	end \nend \n \n//////////--------------------------------------------------------------------------------------------------------------= \n// decide if to draw the pixel or not \nassign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   \n \nendmodule"

    pixels = imgBMP.load()
    width, height = imgBMP.size
    OneBitPixelCode = (255, 0, 0)
    file1 = open(FileName + "BitMap.sv", "w")

    file1.write(verilogText1 + " module " + FileName + "BitMap (\n")
    file1.write(verilogText2 + " \n")
    if (SingleBitBitMap):
        file1.write(verilogText3A)
    file1.write(verilogText3 + " \n")
    if (SingleBitBitMap):
        file1.write("logic[0:"+ str (height-1 ) + "][0:" + str (width -1) + "] object_colors = {")
    else:
        file1.write("logic[0:" + str(height - 1) + "][0:" + str(width - 1) + "][7:0] object_colors = {")
    for j in range(height):  # for each column
        if (SingleBitBitMap):
            file1.write("\n\t" + str(width) + "'b")
            for i in range(width):  # For each row
                #BW
                if (pixels[i,j] == OneBitPixelCode) :
                    file1.write('1')
                    pixels[i, j] = (255, 255, 255)
                else:
                    file1.write('0')
                    pixels[i, j] = (0, 0, 0)

            if j < (height - 1):
                file1.write(",")
        else:
            file1.write("\n\t{")
            for i in range(width):  # For each row
                #RRRGGGBB
             #   ColorByte=int((pixels[i, j][0]/32)+(pixels[i, j][1]/8)+(pixels[i, j][2])) #  sum the three colors to a BYTE
                red1  =  int(pixels[i,j][0] /32) * 32
                green1 = int(pixels[i,j][1] /32) * 4
                blue1 =  int(pixels[i,j][2] /64) * 1

                ColorByte=  red1 + green1 + blue1  # sum the three colors to a BYTE
                file1.write("8'h")
                file1.write(format(ColorByte, '02x'))
                if i < (width -1) :
                    file1.write(",")
            file1.write("}")
            if j < (height - 1):
                file1.write(",")
    file1.write("};\n" +verilogText4 + " \n")
    xBitsDiv = str( math.trunc(math.log(width +1 )  / math.log( 2 ) ) -2 ) # add one to r0und up math errors  -2  to reach the  4*4
    yBitsDiv = str( math.trunc(math.log(height +1 )  / math.log( 2 ) ) -2 )

    file1.write("			HitEdgeCode <= hit_colors[offsetY >> " +  yBitsDiv +"][offsetX >> " +  xBitsDiv + " ]; // get hitting edge from the colors table")
    if (SingleBitBitMap):
        file1.write(verilogText5 + " \n")
    else:
        file1.write(verilogText5A + " \n")

    file1.close()


    # write BMP for additional editing

    outJPGFile = open(FileName + "_piexl.jpg", "w")
    imgBMP.save(outJPGFile)


    sys.exit()

# --------------------------------------------

#    - all image filters

def ResetToOriginal():
    global imgOriginal,Rlambda,Glambda,Blambda
    imgOriginal = imgFromFile.resize(imgOriginal.size, Image.NEAREST)

    Rlambda.set(100)
    Glambda.set(100)
    Blambda.set(100)
    picModify(0)
    OriginalpicDisplay()


def EdgeEnhanceKey():
    global imgOriginal
    imgOriginal = imgOriginal.filter(ImageFilter.EDGE_ENHANCE_MORE)
    picModify(0)


def SharpenKey():
    global imgOriginal
    imgOriginal = imgOriginal.filter(ImageFilter.SHARPEN)
    picModify(0)


def FIND_EDGESKey():
    global imgOriginal
    imgOriginal = imgOriginal.filter(ImageFilter.FIND_EDGES)
    picModify(0)

def SMOOTHKey():
    global imgOriginal
    imgOriginal = imgOriginal.filter(ImageFilter.SMOOTH)
    picModify(0)

def EMBOSSKey():
    global imgOriginal
    imgOriginal = imgOriginal.filter(ImageFilter.EMBOSS)
    picModify(0)

def SMOOTH_MOREKey():
    global imgOriginal
    imgOriginal = imgOriginal.filter(ImageFilter.SMOOTH_MORE)
    picModify(0)

def EDGE_ENHANCE_MOREKey():
    global imgOriginal
    imgOriginal = imgOriginal.filter(ImageFilter.EDGE_ENHANCE_MORE)
    picModify(0)

def EDGE_ENHANCEKey():
    global imgOriginal
    imgOriginal = imgOriginal.filter(ImageFilter.EDGE_ENHANCE)
    picModify(0)

def DETAILKey():
    global imgOriginal
    imgOriginal = imgOriginal.filter(ImageFilter.DETAIL)
    picModify(0)

def CONTOURKey():
    global imgOriginal
    imgOriginal = imgOriginal.filter(ImageFilter.CONTOUR)
    picModify(0)

def BLURKey():
    global imgOriginal
    imgOriginal = imgOriginal.filter(ImageFilter.BLUR)
    picModify(0)


##



##

# ____________________________________________________________________________________________________
def open_img():
    global FileName
    global imgOriginal, imgFromFile
    global imgBMP

    path = "smiley.jpg"
    path = filedialog.askopenfilename( filetypes=[("jpg, bmp", '*.jpg *.bmp'),("all files", '*.*')], title="Choose filename")

    img1 = Image.open(path).convert('RGB')
    width, height = img1.size
    #print ( width)
    #print ( height)
    Image_ratio_float = width /  height
    #print ( Image_ratio_float)
    # ratio calculate based on the picture aspect ratio
    Image_ratio_integer= Image_ratio_float * 256

    if Image_ratio_integer > 4900:
        OriginalImageTruncedSize = (256, 8)
    elif Image_ratio_integer > 2500:
        OriginalImageTruncedSize = (256, 16)
    elif Image_ratio_integer > 1200:
        OriginalImageTruncedSize = (256, 32)
    elif Image_ratio_integer > 600:
        OriginalImageTruncedSize = (256,64)
    elif Image_ratio_integer > 300:
        OriginalImageTruncedSize = (256,128)
    elif Image_ratio_integer > 150:
        OriginalImageTruncedSize = (256,256)
    elif Image_ratio_integer > 75:
        OriginalImageTruncedSize = (128, 256)
    elif Image_ratio_integer > 40:
        OriginalImageTruncedSize = (64, 256)
    elif Image_ratio_integer > 20:
        OriginalImageTruncedSize = (32, 256)
    elif Image_ratio_integer > 10:
        OriginalImageTruncedSize = (16, 256)
    else:
        OriginalImageTruncedSize = (8, 256)


     # create the original image,used for all later conversions
    imgFromFile = img1.resize(OriginalImageTruncedSize,Image.NEAREST)
    imgOriginal = imgFromFile.resize(imgFromFile.size, Image.NEAREST)

 #  copy
    # get the bare filename for the verilog file
    list = path.split('/')
    pro = list.pop()
    FileName  = pro.split('.')[0]

    # create initial original image and print

    img255 = ImageTk.PhotoImage(imgOriginal)
    LeftImage = Label(root, image=img255)
    LeftImage.place(x=Original_Position[0], y=Original_Position[1])
    LeftImage.image = imgOriginal
    OriginalpicDisplay()

    # create initial BMP image and print
    imgBMP = imgOriginal
    OpenGUIKeys()
    BMPpicDisplay()


    # ____________________________________________________________________________________________________
def picModify(v):
    # Split into 3 channels,  pixilize color t o8 bits, pixelize to imgBMP.size 
    global imgBMP, bmpScale

    # resize

    BMP_ratio = pow(2, bmpScale.get())
    width, height = imgOriginal.size
    BMP_ratio = min(BMP_ratio,width, height)  #  so it is minmal
    imgBMPsize = (int(width / BMP_ratio) ,int ( height / BMP_ratio ))

    # https://pillow.readthedocs.io/en/stable/reference/Image.html   filter types
    #print ("width- ", width,"BMP_ratio- ", BMP_ratio )
    #print ("height- ", height,"BMP_ratio- ", BMP_ratio )
    #print ("imgBMPsize- ", imgBMPsize)
    #imgBMP = imgOriginal.resize(imgBMPsize,Image.NEAREST)
    #imgBMP = imgOriginal.resize(imgBMPsize,Image.BILINEAR)
#    im2 = imgOriginal.filter(ImageFilter.EDGE_ENHANCE_MORE)
 #   im2 = im2.filter(ImageFilter.SHARPEN)
    SizeText = (str(imgBMPsize[0]) + "*" +  str (imgBMPsize[1]))
    bmpScale.config(label=SizeText)
    # Image.NEAREST (0), Image.LANCZOS (1), Image.BILINEAR (2), Image.BICUBIC (3), Image.BOX (4) or Image.HAMMING (5)
    imgBMP = imgOriginal.resize(imgBMPsize,  resample=ResizeScale.get())

    #imgBMP = imgOriginal.resize(imgBMPsize,Image.ANTIALIAS)
    # filters =  https://pillow.readthedocs.io/en/3.0.0/reference/ImageFilter.html#module-PIL.ImageFilter
    # resize = https://pillow.readthedocs.io/en/3.0.0/reference/Image.html

      #  8 bit RGB
    r, g, b = imgBMP.split()

    #r = r.point(lambda i: math.floor(math.floor(i * Rlambda.get() / 100.0 )/ 64 )* 64)
    #g = g.point(lambda i: math.floor(math.floor(i * Glambda.get() / 100.0 )/ 64 )* 64)
    #b = b.point(lambda i: math.floor(math.floor(i * Blambda.get() / 100.0 )/ 128 )* 128)

    r = r.point(lambda i: int(int(i * Rlambda.get() / 100.0 )/ 64 )* 64)
    g = g.point(lambda i: int(int(i * Glambda.get() / 100.0 )/ 64 )* 64)
    b = b.point(lambda i: int(int(i * Blambda.get() / 100.0 )/ 64 )* 64)


    # Recombine back to RGB image
    imgBMP = Image.merge('RGB', (r, g, b))
    #pixels = imgBMP.load()  # create the pixel map
    #for i in range(imgBMP.size[0]):  # for each column
        #for j in range(imgBMP.size[1]):  # For each row
            #print(pixels[i, j])

    # perform only on grayScale image
    if SingleBitBitMap :
        pixels = imgBMP.load()  # create the pixel map
        for i in range(imgBMP.size[0]):  # for each column
            for j in range(imgBMP.size[1]):  # For each row
                gray = int(pixels[i, j][0] * 0.2125 + pixels[i, j][1] * 0.7154 + pixels[i, j][2] * 0.0721)
                if (gray > grayThreshold.get() and InvertGrayScale)  or (gray < grayThreshold.get() and (not InvertGrayScale) ):
                    pixels[i, j] = (255, 0, 0)  # paint in red
                else :
                    pixels[i, j] = (gray, gray, gray)

    BMPpicDisplay()
    OriginalpicDisplay()


# main

# open gui window
root = Tk()  # blank window
theLabel = Label(root, text="Lab 1 Picture to SV bitmap Converter \n (c) Technion IIT July 2021")  # basic text
theLabel.pack()  # display it on the window
root.geometry("800x600+200+0")  # place on screen- size, x,y


open_img()
# print the left Original image

root.bind("<Button-1>", selectmouse)

root.mainloop()


# _______________________________________________________mouse detection_________________________________________________

# ____________________________________________________display original picture____________________________________________
