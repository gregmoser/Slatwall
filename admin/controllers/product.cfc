/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="BaseController" output=false accessors=true {

	// fw1 Auto-Injected Service Properties
	property name="productService" type="Slatwall.com.service.ProductService";
	property name="brandService" type="Slatwall.com.service.BrandService";
	property name="skuService" type="Slatwall.com.service.SkuService";
	property name="attributeService" type="Slatwall.com.service.AttributeService";
	property name="requestCacheService" type="Slatwall.com.service.RequestCacheService";
	
	public void function before(required struct rc) {
		param name="rc.productID" default="";
		param name="rc.keyword" default="";
		param name="rc.edit" default="false";
	}
	
	public void function dashboard(required struct rc) {
		getFW().redirect(action="admin:product.list");
	}

    public void function create(required struct rc) {
		if(!structKeyExists(rc,"product") or !isObject(rc.product) or !rc.product.isNew()) {
			rc.product = getProductService().newProduct();
		}
		rc.optionGroups = getProductService().listOptionGroupOrderBySortOrder();
    }
	
	public void function detail(required struct rc) {
		param name="rc.edit" default="false";
		rc.product = getProductService().getProduct(rc.productID);
		if(!isNull(rc.product) ) {
			if(len(rc.product.getProductName())) {
				rc.itemTitle &= ": #rc.product.getProductName()#";
			}
		} else {
			getFW().redirect("admin:product.list");
		}
		rc.productPages = getProductService().getProductPages(siteID=rc.$.event('siteid'), returnFormat="nestedIterator");
		rc.attributeSets = rc.Product.getAttributeSets(["astProduct"]);
		rc.skuSmartList = getSkuService().getSkuSmartList(productID=rc.product.getProductID() ,data=rc);
		rc.categories = getProductService().getProductCategories(siteID=rc.$.event('siteid'));
	}
	
	public void function edit(required struct rc) {
		detail(rc);
		getFW().setView("admin:product.detail");
		rc.edit = true;
	}

	public void function list(required struct rc) {
		rc.productSmartList = getProductService().getProductSmartList(data=arguments.rc);
	}
	
	public void function save(required struct rc) {
		param name="rc.productID" default="";
		var isNew = 0;
		
		rc.product = getProductService().getProduct(rc.productID, true);
		
		if(rc.product.isNew()) {
			isNew = 1;
		}
		
		if(isNew) {
			// set up options struct for generating skus if this is a new product
			rc.optionsStruct = getService("formUtilities").buildFormCollections(rc);
		} else {
			// set up sku array to handle any skus that were edited and/or added
			var formCollections = getService("formUtilities").buildFormCollections(rc);
			rc.skuArray = formCollections.skus;
			if(structKeyExists(formCollections,"attribute")){
				rc.attributes = formCollections.attribute;
			} else {
				rc.attributes = {};
			}
		}

		// Attempt to Save Product
		rc.product = getProductService().save( rc.product,rc );
		
		// Redirect & Error Handle
		if(!getRequestCacheService().getValue("ormHasErrors")) {
			// add product details if this is a new product
			if(isNew) {
			     getFW().redirect(action="admin:product.edit",queryString="productID=#rc.product.getProductID()#");
            } else {
            	rc.message = "admin.product.save_success";
            	getFW().redirect(action="admin:product.list",preserve="message");
            }
		} else {
			rc.message = rc.$.Slatwall.rbKey("admin.product.save_error");
			rc.messageType = "error";
			if(isNew) {
				rc.optionGroups = getProductService().listOptionGroupOrderByOptionGroupName();
				rc.itemTitle = rc.$.Slatwall.rbKey("admin.product.create");
				getFW().setView(action="admin:product.create");
			} else {
				rc.edit = true;
				rc.productPages = getProductService().getProductPages(siteID=rc.$.event('siteid'), returnFormat="nestedIterator");
				rc.attributeSets = rc.Product.getAttributeSets(["astProduct"]);
				rc.skuSmartList = getSkuService().getSkuSmartList(productID=rc.product.getProductID() ,data=rc);
				rc.itemTitle = rc.$.Slatwall.rbKey("admin.product.edit") & ": #rc.product.getProductName()#";
				getFW().setView(action="admin:product.detail");
			}
		}
	}
	
	public void function delete(required struct rc) {
		var product = getProductService().getProduct(rc.productID);
		var deleteResponse = getProductService().delete(product);
		if(deleteResponse.hasErrors()) {
			rc.message = rbKey("admin.product.delete_success");
		} else {
			rc.message=deleteResponse.getErrorBean().getError("delete");
			rc.messagetype="error";
		}
		getFW().redirect(action="admin:product.list",preserve="message");
	}
	
	// SKU actions
	
	public void function deleteSku(required struct rc) {
		var sku = getSkuService().getSku(rc.skuID);
		var productID = sku.getProduct().getProductID();
		var deleteResponse = getSkuService().delete(sku);
		if(!deleteResponse.hasErrors()) {
			rc.message = rbKey("admin.product.deleteSku_success");
		} else {
			rc.message = deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype = "error";
		}
		getFW().redirect(action="admin:product.edit",querystring="productID=#productID#",preserve="message,messagetype");
	}
	
	public void function uploadSkuImage(required struct rc) {
		rc.sku = getSkuService().getSku(rc.skuID);
		
		// upload the image and return the result struct if there was an upload
		if(structKeyExists(rc, "skuImageFile") && rc.skuImageFile != "") {
			var imageUploadResult = fileUpload(getTempDirectory(),"skuImageFile","","makeUnique");
			rc.uploadSuccess = getSkuService().processImageUpload(rc.sku, imageUploadResult);
			if(rc.uploadSuccess) {
				rc.message = rc.$.Slatwall.rbKey("admin.product.uploadSkuImage_success");
			} else {
				rc.message = rc.$.Slatwall.rbKey("admin.product.uploadSkuImage_error");
				rc.messagetype = "error";
			}
			getFW().redirect(action="admin:product.edit",querystring="productID=#rc.sku.getProduct().getProductID()#",preserve="message,messagetype");
		} 
	}
	
	//   Product Type actions      
		
	public void function createProductType(required struct rc) {
	   rc.edit=true;
	   rc.productType = getProductService().newProductType();
	   rc.attributeSets = getAttributeService().getAttributeSets(["astProduct","astProductCustomization"]);
	   getFW().setView("admin:product.detailproducttype");
	}
		
	public void function editProductType(required struct rc) {	
	   	rc.productType = getProductService().getProductType(rc.productTypeID);
		rc.attributeSets = getAttributeService().getAttributeSets(["astProduct","astProductCustomization"]);
	   	if(!isNull(rc.productType)) {
	   		rc.edit = true;
		   	rc.itemTitle &= ": " & rc.productType.getProductTypeName();
		   	getFW().setView("admin:product.detailproducttype");
	   	} else {
           	getFW().redirect("admin:product.listproducttypes");
		}
	}
	
	public void function listProductTypes(required struct rc) {
       rc.productTypes = getProductService().getProductTypeTree();
	}
	
	public void function detailProductType(required struct rc) {
		rc.productType = getProductService().getProductType(rc.productTypeID);
		rc.attributeSets = getAttributeService().getAttributeSets(["astProduct","astProductCustomization"]);
		if(isNull(rc.productType)) {
			getFW().redirect("admin:product.listProductTypes");
		} else {
			rc.itemTitle &= ": " & rc.productType.getProductTypeName();
		}
	}
	
	public void function saveProductType(required struct rc) {
		param name="rc.productTypeID" default="";
		
		rc.productType = getProductService().getProductType(rc.productTypeID, true);
		
		rc.productType = getProductService().saveProductType(rc.productType,rc);
		
		if(!rc.productType.hasErrors()) {
			// no errors, redirect to list with success message
			rc.message = "admin.product.saveproducttype_success";
		  	getFW().redirect(action="admin:product.listproducttypes",preserve="message");
		} else {
			// errors, so show edit view again
		  rc.edit = true;
		  rc.attributeSets = getAttributeService().getAttributeSets(["astProduct","astProductCustomization"]);
		  rc.itemTitle = rc.productType.isNew() ? rc.$.Slatwall.rbKey("admin.product.createProductType") : rc.$.Slatwall.rbKey("admin.product.editProductType") & ": #rc.productType.getProductTypeName()#";
		  getFW().setView(action="admin:product.detailproducttype");
        }
	}
	
	public void function deleteProductType(required struct rc) {
		var productType = getProductService().getProductType(rc.productTypeID);
		var deleteResponse = getProductService().deleteProductType(productType);
		if(!deleteResponse.hasErrors()) {
			rc.message = rbKey("admin.product.deleteProductType_success");
		} else {
			rc.message=deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype="error";
		}
		getFW().redirect(action="admin:product.listproducttypes",preserve="message,messagetype");
	}
		
}
