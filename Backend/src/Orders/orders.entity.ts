import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Order {
    @PrimaryGeneratedColumn()
	public id!: number;

    @Column()
	public authId: number;

    @Column()
	public number: number;

    @Column()
	public productId: string;

    @Column()
	public productPrevieew: string;

    @Column()
	public productQuantity: number;

    @Column()
	public productSize: string;

    @Column()
	public createdAt: string;

    @Column()
	public etd: string;

    @Column()
	public deliveryAddress: string;

    @Column()
	public status: string;
}