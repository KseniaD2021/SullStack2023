import { Column, Entity, PrimaryGeneratedColumn, OneToMany, JoinColumn } from "typeorm";

@Entity()
export class Product{
    @PrimaryGeneratedColumn()
	public id!: number;
    
    @Column()
	public title: string;

    @Column()
	public departments: string;

    @Column()
	public price: number;

    @Column()
	public badge: ProductBadge;

    @Column()
	public preview: string;

    @Column()
	public description: string;
}

export class ProductBadge{
    @Column()
	public value: string;

    @Column()
	public color: string;
}