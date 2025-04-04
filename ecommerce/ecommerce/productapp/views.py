from django.shortcuts import render
from rest_framework import viewsets
from rest_framework.response import Response
from .models import Brand,Category,Product,productdetail
from.serializer import brandSerializer,categorySerializer,productSerializer,productdetailSerializer
from drf_spectacular.utils import extend_schema
from rest_framework.decorators import action
# Create your views here.
class brandviewset(viewsets.ViewSet):
    serializer_class = brandSerializer
    @extend_schema(
        request=brandSerializer,
    
       
    )
    def list(self, request):
        queryset=Brand.objects.all();
        serializer=brandSerializer(queryset,many=True)
        return Response(serializer.data)
    
    def create(self,request):
        serializer=brandSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({'msg':'created sucessfully'})
    

class categoryviewset(viewsets.ViewSet):
    serializer_class = categorySerializer
    @extend_schema(
        request=categorySerializer,
      
       
    )
    def list(self, request):
        queryset=Category.objects.all();
        serializer=categorySerializer(queryset,many=True)
        return Response(serializer.data)
    def create(self,request):
        serializer=categorySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({'msg':'created sucessfully'})
     
class productviewset(viewsets.ViewSet):
    queryset=Product.objects.all();

    # if we did detail is true then i have to tgive product id for get product which is not necessary
    
    @action(url_path=r'category/(?P<category>[^/]+)/all' 
            ,detail=False, 
             methods=['get'] )

    def list_by_category(self,request,category=None):
        serialized=productSerializer(self.queryset.filter(category__name=category),many=True)
        return Response(serialized.data)
    

    serializer_class = productSerializer
    @extend_schema(
        request=productSerializer ,
        
       
    )
    def list(self, request):
       
        serializer=productSerializer(self.queryset,many=True)
        return Response(serializer.data)
    def create(self,request):
        serializer=productSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({'msg':'created sucessfully'})
class productdetailviewset(viewsets.ViewSet):
    serializer_class = productdetailSerializer
    @extend_schema(
        request=productdetailSerializer ,
        
       
    )
    def list(self, request):
        queryset=productdetail.objects.all();
        serializer=productdetailSerializer(queryset,many=True)
        return Response(serializer.data)
    def create(self,request):
        serializer=productdetailSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({'msg':'created sucessfully'})