public with sharing class Product2Manager {
	public static Product2 getInactiveProducts(Product2[] triggerProducts) {
		if (triggerProducts.isEmpty())
			return null;
		List<Product2> products = [SELECT Id, Name FROM Product2 WHERE Id IN :triggerProducts AND IsActive = FALSE];
		if (products.isEmpty())
			return null;
		return products;
	}
}
