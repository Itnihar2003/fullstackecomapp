from django.shortcuts import render
from rest_framework import viewsets
from rest_framework.response import Response
from .models import Brand,Category,Product,productdetail,userdata2
from.serializer import brandSerializer,categorySerializer,productSerializer,productdetailSerializer,userserializer2
from drf_spectacular.utils import extend_schema
from rest_framework.decorators import action
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.permissions import IsAuthenticated

# Create your views here.
class brandviewset(viewsets.ViewSet):
    authentication_classes=[JWTAuthentication]
    permission_classes=[IsAuthenticated]
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
     
class productviewset(viewsets.ModelViewSet):
    # authentication_classes=[JWTAuthentication]
    # permission_classes=[IsAuthenticated]
    queryset=Product.objects.all();

    # if we did detail is true then i have to tgive product id for get product which is not necessary
    queryset = Product.objects.all()
    serializer_class = productSerializer
    
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

class userviewset2(viewsets.ViewSet):
    def create(self,request):
        serializer=userserializer2(data=request.data)
        print( serializer)
        if serializer.is_valid():
            username=serializer.data["username"]
            print(username)
            password=serializer.data["password"]
          
            user = authenticate(username=username,password = password)
            print(user)
            if user is None:
                return Response({'status':400,'msg':'invalid Password','data':serializer.errors})
            refresh = RefreshToken.for_user(user)
            return Response({'statusCode':201,'msg':'sucessfully login',
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                })
            
        return Response({'status':400,'msg':'something went wrong','data':serializer.errors})


            
