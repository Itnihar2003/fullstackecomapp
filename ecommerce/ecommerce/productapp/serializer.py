from rest_framework import serializers
from.models import Brand,Category,Product,productdetail
class brandSerializer(serializers.ModelSerializer):
    class Meta:
        model = Brand
        fields = '__all__'
class categorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'




class productdetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = productdetail
        fields = '__all__'

class productSerializer(serializers.ModelSerializer):

    # to show all data of brand and  category we have to use nestedserializer
    # brand=brandSerializer()
    # category=categorySerializer()
#    only fatching name of brand and category not all detail
    brand_name=serializers.CharField(source="brand.name")

    category_name=serializers.CharField(source="category.name")
    
    product_detail=productdetailSerializer(many=True) 
    

    class Meta:
        model = Product
        fields = ("name","describtion","is_digital","brand_name","category_name","product_detail")
