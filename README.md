# batch-table

## 说明
batch表格. 读取数据文件，数据列以#分割


## 调用参数
* [-b borderStyle] [-a alignStyle] [-l linePrefixLen] dataFile
* borderStyle - 表格样式(1[┌┬┐├┼┤└┴┘]  2[┏┳┓┣╋┫┗┻┛] 3[╔╦╗╠╬╣╚╩╝] 4[┼┼┼├┼┤┼┼┼] 5[···├┼┤···] 6[·········]), 默认为·········
* alignStyle - 表格对齐方式[left middle right], 默认为middle
* linePrefixLen - 绘制的表格左右空白宽度, 默认为10
* dataFile - 传入数据文件地址,为空时,展示demo数据



## 预览
<div align=center><img src="https://github.com/bjc5233/batch-table/raw/master/resources/demo.png"/></div>
<div align=center><img src="https://github.com/bjc5233/batch-table/raw/master/resources/demo2.png"/></div>
<div align=center><img src="https://github.com/bjc5233/batch-table/raw/master/resources/demo3.png"/></div>
