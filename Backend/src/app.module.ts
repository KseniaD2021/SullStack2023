import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModel } from './Auth/auth.module';
import { PersonsModel } from './Persons/persons.module';
import { ProductModel } from './Product/product.module';
import { OrdersModel } from './Orders/orders.module';

@Module({
	imports: [
		TypeOrmModule.forRoot({
			type :"sqlite",
			database: "ShopOnline",
			entities: [__dirname + "/**/*.entity{.ts,.js}"],
			synchronize: true
		}),
		AuthModel,
		PersonsModel,
		ProductModel,
		OrdersModel
	],
	controllers: [AppController],
	providers: [AppService],
})
export class AppModule { }
