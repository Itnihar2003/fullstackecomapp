from django.contrib import admin
from .models import Product,Category,Brand,productdetail,userdata2
# Register your models here.

class Productinline(admin.TabularInline):
    model = productdetail
    
@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    inlines = [
       Productinline
    ]

admin.site.register(Category)
admin.site.register(Brand)
admin.site.register(userdata2)
