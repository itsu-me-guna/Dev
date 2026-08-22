import os
import sys
from Library.get_my_spark import *

spark = this_is_my_spark("MySparkApplication")

print(spark)
# customer
spark.read.format("csv").options(header=True, nullValue="NULL", inferSchema=True ).load(r"E:\Class\Project\sample_files\001_sales_copy.csv").show()