import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from './orders.entity';

@Injectable()
export class OrdersService {
	@InjectRepository(Order)
    private readonly repository: Repository<Order>;

    public findAllOrders(): Promise<Order[]> {
        return this.repository.find();
    }

    public createOrder(oder: Order): Boolean {
        this.repository.save(oder);
        return true;
    }

    public deleteOrderById(id: number): Boolean {
        this.repository.delete(id);
        return true;
    }
}