namespace SueTheChef
{
    /// <summary>Cart row for binding (PRODUCTS joined with session qty).</summary>
    public sealed class CartLineVm
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string ProductType { get; set; }
        public string ImageUrl { get; set; }
        public decimal UnitPrice { get; set; }
        public int Quantity { get; set; }

        public decimal LineTotal
        {
            get { return UnitPrice * Quantity; }
        }
    }
}
