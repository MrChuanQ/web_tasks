#coding=utf-8
import urllib   #urllib模块提供了读取web页面的接口
import re       #re模块通过正则表达式进行匹配

#通过URL地址访问web页面，将读取到的信息保存到html变量中
def getHtml(url):
    page = urllib.urlopen(url)  #访问url地址对应的web页面
    html = page.read()  #读取web页面信息（即html代码）并保存在html中
    return html


#对web信息进行通过正则表达式查找需要的图片地址信息,通过图片的地址将图片下载到本地
def getImg(html):
    '''
    定义正则表达式 r表示字符串以原始方式使用，不需要转译
    匹配格式为 src=“---.jpg”或srcs=“---.gif”
    其中src+表示src字符串最少重复一次，s*表示字符s最少重复0次。即被匹配的对象以scr或srcs为开头
    整个正则表达式（）中的为子模式，查找时按整个正则表达式进行匹配
    .为通配符，可匹配所有的字符。
    .+?表示.jpg或.gif前至少要有有一个字符,且当第一次匹配后，重新对整个正则表达式进行匹配。
    通过子模式匹配保存的是与子模式匹配的字符串，即舍弃了src[s]=""的部分
    '''
    reg = r'src+s*="(.+?\.jpg|.+?\.gif)"'

    imgre = re.compile(reg) #将正则表达式字符串转换成一个正则表达式对象
    imglist = re.findall(imgre,html)    #通过正则表达式对象在html中查找与其匹配的字符串，并保存在列表中

    x = 0   #记录图像编号
    for imgurl in imglist:
        #获取图片格式,从右往左查找
        index = imgurl.rfind(".jpg")
        if index == -1 :
            index = imgurl.rfind(".gif")
        imgtype = imgurl[index:]
        #根据图片的URL下载相应的图片,保存到代码所在的文件夹下,名称为 x.jpg或x.gif
        urllib.urlretrieve(imgurl,'%d%s' % (x,imgtype))
        x+=1
    return imglist  #返回图片下载地址的列表

#通过web页面URL访问并获取web信息
html = getHtml("http://desk.zol.com.cn/bizhi/7065_87643_2.html")
print getImg(html) #打印图片下载地址