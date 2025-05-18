from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from ecommerce.productapp.views import brandviewset, productviewset, categoryviewset, productdetailviewset, userviewset2
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView
from django.conf import settings
from django.conf.urls.static import static
from django.contrib.staticfiles.urls import staticfiles_urlpatterns

router = DefaultRouter()
router.register(r'brand/', brandviewset, basename='brand')
router.register(r'category/', categoryviewset, basename='category')
router.register(r'product', productviewset, basename='product')
router.register(r'productdetail/', productdetailviewset, basename='productdetail')
router.register(r'login/', userviewset2, basename='login')

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include(router.urls)),
    # path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    # path('advanceapi/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
]

urlpatterns += staticfiles_urlpatterns()
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
