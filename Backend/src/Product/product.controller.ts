import { Controller, Get, Post, Body, Put, Param, Delete } from '@nestjs/common';
import { ProductService } from './product.service';
import { Product } from './product.entity';

@Controller()
export class ProductController {
	public constructor(
		private readonly productService: ProductService)
	{ }


	@Get('products')
	public async getAllCities(): Promise<Product[]> {
		return this.productService.findAllProducts();
	}

	@Get('product/:id')
	public async getCityById(@Param('id') id: number): Promise<Product> {
		return this.productService.findProductById(id);
	}

	// @Post('city')
	// public async createCity(@Body() city: City) : Promise<void>  {
	// 	return this.citiesService.createCity(city);
	// }

	// @Put('city/:id')
	// public async updateCityById(@Param('id') id: number, @Body() city: City) : Promise<void> {
	// 	return this.citiesService.updateCityById(id, city);
	// }

	// @Delete('city/:id')
	// public async deleteCityById(@Param('id') id: number) : Promise<void> {
	// 	return this.citiesService.deleteCityById(id);
	// }
}
