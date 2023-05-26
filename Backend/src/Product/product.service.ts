import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from './product.entity';

@Injectable()
export class ProductService {
	@InjectRepository(Product)
	private readonly repository: Repository<Product>;

	public findAllProducts(): Promise<Product[]> {
		return this.repository.find();
	}

	public findProductById(id: number): Promise<Product> {
		return this.repository.findOneBy({ "id": id });
	}
}
