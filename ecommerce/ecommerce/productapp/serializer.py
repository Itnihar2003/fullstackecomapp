from rest_framework import serializers
from.models import Brand,Category,Product,productdetail,userdata2
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
   # to show all data of brand and  category we have to use nestedserializer
    # brand=brandSerializer()
    # category=categorySerializer()
#    only fatching name of brand and category not all detail
class productSerializer(serializers.ModelSerializer):
    brand_name = serializers.CharField(source="brand.name")
    category_name = serializers.CharField(source="category.name")
    base_category_name = serializers.SerializerMethodField()
    product_detail = productdetailSerializer(many=True, read_only=True)
    added_to_cart = serializers.BooleanField()
    class Meta:
        model = Product
        fields = (
            "name",
            "image",
            "describtion",
            "is_digital",
            "brand_name",
            "category_name",
            "added_to_cart",
            "base_category_name",
            "product_detail",
        )

    def get_base_category_name(self, obj):
        category = obj.category
        while category.parent is not None:
            category = category.parent
        return category.name



class userserializer2(serializers.ModelSerializer):
    class Meta:
        model = userdata2
        fields = '__all__'
        