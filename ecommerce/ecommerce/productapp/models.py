from django.db import models
from mptt.models import MPTTModel, TreeForeignKey
# Create your models here.
class Brand(models.Model):
    name=models.CharField(max_length=200)

    def __str__(self):
        return self.name



class Category(MPTTModel):
    name=models.CharField(max_length=200)
    # due to multiple tree like categories so we use mptt
    parent=TreeForeignKey('self', on_delete=models.PROTECT, null=True, blank=True )

    class MPTTMeta:
        order_insertion_by = ['name']
    def __str__(self):
        return self.name

class Product(models.Model):
    name=models.CharField(max_length=200)
    describtion=models.TextField()
    is_digital=models.BooleanField(default=False)
    brand=models.ForeignKey(Brand,on_delete=models.CASCADE)
    category=TreeForeignKey('Category', on_delete=models.CASCADE, null=True, blank=True )
    image = models.ImageField(upload_to='product_images/', null=True, blank=True)
    added_to_cart = models.BooleanField(default=False)
    
    def __str__(self):
        return self.name

class productdetail(models.Model):
    price=models.DecimalField(decimal_places=2,max_digits=5)
    stock_quantity=models.IntegerField()
    sku=models.CharField(max_length=100)
    product=models.ForeignKey(Product,on_delete=models.CASCADE,related_name="product_detail")
    is_active=models.BooleanField(default=False)
    def __str__(self):
        return self.sku

class userdata(models.Model):
    mail=models.EmailField()
    
    password=models.CharField(max_length=50)

class userdata2(models.Model):
    username=models.CharField(max_length=50)
    password=models.CharField(max_length=50)





