
from django.contrib import admin
from django.urls import path,include
from rest_framework.routers import DefaultRouter
from ecommerce.productapp.views import brandviewset,productviewset,categoryviewset,productdetailviewset
from drf_spectacular.views import SpectacularAPIView,  SpectacularSwaggerView
router =DefaultRouter()
router.register(r'brand/',brandviewset, basename='brand')
router.register(r'category/',categoryviewset, basename='category')
router.register(r'product',productviewset, basename='product')
router.register(r'productdetail/',productdetailviewset, basename='productdetail')
urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include(router.urls)),
     # YOUR PATTERNS
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    # Optional UI:
    path('advanceapi/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
]
