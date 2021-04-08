public with sharing class OpportunityLineItemManager {
	public static OpportunityLineItem getOpportunityWithInactiveProducts(List<Product2> inactiveProducts) {
		if (inactiveProducts.isEmpty())
			return null;
		List<OpportunityLineItem> oppInactiveProd = [
			SELECT Id, Name, OpportunityId, Product2Id
			FROM OpportunityLineItem
			WHERE Product2Id IN :inactiveProducts
		];
		if (oppInactiveProd.isEmpty())
			return null;
		return oppInactiveProd;
	}
}
